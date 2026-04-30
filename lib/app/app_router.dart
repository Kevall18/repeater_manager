import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'loading_splash_screen.dart';
import 'startup_splash_gate.dart';

import '../modules/auth/bloc/auth_cubit.dart';
import '../modules/auth/bloc/auth_state.dart';
import '../modules/auth/screen/login_screen.dart';
import '../modules/auth/screen/signup_screen.dart';
import '../modules/home/bloc/home_cubit.dart';
import '../modules/home/repository/home_repository.dart';
import '../modules/home/screen/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter createRouter({
    required AuthCubit authCubit,
    required HomeRepository homeRepository,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _GoRouterRefreshNotifier(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.signup;

        // Only show splash on initial app load, never again after marked
        if (state.matchedLocation == AppRoutes.splash) {
          // If we're already on splash, check if we should proceed
          if (!StartupSplashGate.shouldShowSplash) {
            // Splash has been marked as completed, proceed with auth check
            if (authState.status == AuthStatus.unauthenticated) {
              return AppRoutes.login;
            } else if (authState.status == AuthStatus.authenticated) {
              return AppRoutes.home;
            } else if (authState.status == AuthStatus.initializing) {
              // Still initializing, stay on splash until ready
              return null;
            }
          }
          // Stay on splash
          return null;
        }

        // If splash should be shown and we're not on it, go there
        if (StartupSplashGate.shouldShowSplash &&
            authState.status == AuthStatus.initializing) {
          return AppRoutes.splash;
        }

        if (authState.status == AuthStatus.unauthenticated) {
          return isOnAuthRoute ? null : AppRoutes.login;
        }

        if (authState.status == AuthStatus.authenticated) {
          if (isOnAuthRoute) {
            return AppRoutes.home;
          }

          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splashName,
          builder: (context, state) {
            return const LoadingSplashScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) {
            return BlocProvider<HomeCubit>(
              create: (_) => HomeCubit(repository: homeRepository)..load(),
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: AppRoutes.signupName,
          builder: (context, state) {
            return const SignUpScreen();
          },
        ),
      ],
    );
  }
}

class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Stream stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
