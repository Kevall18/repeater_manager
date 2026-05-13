# Repeater Manager

Web-first Flutter foundation for Firebase-backed module development.

## What Is Set Up

This project is now structured for:

- Firestore-based CRUD and query access through a shared base repository.
- Firebase Auth with shared web persistence so login survives new tabs and logout syncs across tabs.
- Bloc/Cubit state management with `equatable` states and `copyWith` updates.
- Centralized theme, color tokens, and text styles so visual changes happen in one place.
- Responsive layouts for mobile, tablet, and desktop/web through a shared `LayoutBuilder` wrapper.
- `go_router` as the direct routing layer with centralized route constants.
- Common scaffold, app bar, text field, dropdown, and date picker widgets.
- Shared animation and validation helpers for auth forms and other future modules.
- Internet/offline handling at the app scaffold level for web use.
- Module-based structure so future features stay isolated and predictable.

## Setup

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Firebase is initialized for web in `lib/main.dart` using `lib/firebase_options.dart`.

## Firebase Hosting

The app is configured for Firebase Hosting as a Flutter web SPA.

```bash
flutter build web --release
firebase deploy --only hosting
```

The Hosting config serves `build/web` and rewrites all routes to `index.html` so `go_router` works on refresh and direct links.

## Project Structure

```text
lib/
├── app/
│   ├── app.dart
│   ├── app_router.dart
│   ├── app_routes.dart
│   └── app_theme.dart
├── commons/
│   ├── animations/
│   │   └── app_animated_entry.dart
│   ├── app_bar/
│   │   └── app_app_bar.dart
│   ├── app_scaffold/
│   │   └── app_scaffold.dart
│   ├── app_text/
│   │   └── app_text.dart
│   ├── validation/
│   │   └── app_validators.dart
│   ├── network/
│   │   └── no_internet_view.dart
│   ├── responsive/
│   │   └── app_responsive_page.dart
│   └── widgets/
│       ├── app_date_picker_field.dart
│       ├── app_dropdown.dart
│       └── app_text_field.dart
├── core/
│   ├── constants/
│   │   └── app_breakpoints.dart
│   ├── cubits/
│   │   ├── connectivity_cubit.dart
│   │   └── connectivity_state.dart
│   ├── extensions/
│   │   └── build_context_extensions.dart
│   ├── services/
│   │   ├── base_firestore_repository.dart
│   │   └── connectivity_service.dart
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme_colors.dart
└── modules/
    └── auth/
        ├── bloc/
        │   ├── auth_cubit.dart
        │   └── auth_state.dart
        ├── models/
        │   └── app_user.dart
        ├── repository/
        │   ├── auth_repository.dart
        │   └── user_repository.dart
        ├── screen/
        │   ├── login_screen.dart
        │   └── signup_screen.dart
        └── widgets/
            ├── auth_form_shell.dart
            ├── auth_page_header.dart
            └── auth_text_field.dart
    └── home/
        ├── bloc/
        │   ├── home_cubit.dart
        │   └── home_state.dart
        ├── repository/
        │   └── home_repository.dart
        ├── screen/
        │   └── home_screen.dart
        └── widgets/
            └── home_summary_card.dart
```

## Architecture Rules

### Routing

- Use `lib/app/app_router.dart` as the only routing entry point.
- Keep route names and paths in `lib/app/app_routes.dart`.
- Pages should not depend on route arguments for core data when a fresh fetch is possible.
- If routing is replaced later, screens should not need to change.

### State Management

- Use `Cubit` for simple view state and `Bloc` when the state machine becomes more complex.
- Keep states immutable.
- Extend `Equatable` for all bloc and cubit states.
- Expose updates through `copyWith` methods.
- Route entry points should create their cubit and trigger fresh loading on entry.

### Firebase / Firestore

- Use `BaseFirestoreRepository<T>` in `lib/core/services/base_firestore_repository.dart` for common Firestore work.
- Build feature repositories on top of that base class.
- Keep Firestore access inside repositories, not in screens.
- Avoid passing Firestore data between pages as navigation payloads when the page can reload itself.

### Auth

- Keep auth flow in `lib/modules/auth`.
- Use `AuthCubit` for sign in, sign up, sign out, and current-user state.
- Persist web auth in `LOCAL` mode so another tab stays signed in.
- Let Firebase auth state changes drive logout sync across tabs.
- Keep user profile data in the `users` collection through `UserRepository`.
- Use trimmed validation for all auth inputs and validate the confirm-password field on signup.

### Theme

- Change palette values only in `lib/core/theme/app_colors.dart`.
- Change shared text styles only in `lib/commons/app_text/app_text.dart`.
- Theme extensions live in `lib/core/theme/app_theme_colors.dart`.
- `lib/app/app_theme.dart` is the place to wire Material theme output.

### Responsive UI

- Use `AppResponsivePage` for all page-level layouts.
- Supply mobile, tablet, and desktop builders instead of hand-rolling breakpoint logic in every screen.
- Prefer the common scaffold and responsive wrapper together to avoid overflow issues.
- Use the context breakpoint extensions in `lib/core/extensions/build_context_extensions.dart` when needed.

### Common Widgets

- Use `AppScaffold` and `AppAppBar` for page shells.
- Use `AppTextField`, `AppDropdown`, and `AppDatePickerField` for themed form controls.
- Use `AppAnimatedEntry` when forms or sections need staggered entrance animation.
- Use `AppValidators` for trimmed and reusable field validation.
- Use `NoInternetView` when a page or scaffold needs an offline state.

### Internet / Offline

- `ConnectivityCubit` handles connection state for the app.
- `AppScaffold` switches to an offline widget when the app is not connected.
- Web pages should always be able to reload and fetch fresh data when they re-enter the route.

## Feature Pattern

When adding a new module, use this shape:

```text
lib/modules/<feature>/
├── bloc/
│   ├── <feature>_bloc.dart or <feature>_cubit.dart
│   └── <feature>_state.dart
├── repository/
│   └── <feature>_repository.dart
├── screen/
│   └── <feature>_screen.dart
└── widgets/
    └── ...feature-specific widgets...
```

Keep feature logic inside that module. Shared logic belongs in `core` or `commons`.

## Current Behavior

- The app starts from `lib/main.dart`.
- Firebase initializes on web.
- Firebase Auth persistence is set to `LOCAL` on web so tabs share login state.
- The root app uses `MaterialApp.router` with `go_router`.
- Auth routes redirect to login, signup, or home based on the current Firebase auth state.
- The home route creates a fresh cubit and loads fresh module data on entry.
- The test suite includes a smoke test for the app shell.

## Verification

```bash
flutter analyze
flutter test
flutter run -d chrome
```

## Notes For Future Work

- Keep the palette centralized.
- Keep screen state inside bloc/cubit layers.
- Keep Firestore access in repositories.
- Keep responsive decisions in `AppResponsivePage` or shared extensions.
- Keep route definitions centralized in `lib/app`.