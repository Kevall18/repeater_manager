import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../modules/home/bloc/home_cubit.dart';
import '../modules/home/repository/home_repository.dart';
import '../modules/home/screen/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter createRouter({
    required HomeRepository homeRepository,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
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
      ],
    );
  }
}
