import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/cubits/connectivity_cubit.dart';
import '../core/cubits/connectivity_state.dart';
import '../modules/home/repository/home_repository.dart';
import 'app_router.dart';
import 'app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (_) => const HomeRepository(),
        ),
      ],
      child: BlocProvider<ConnectivityCubit>(
        create: (_) => ConnectivityCubit(),
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              title: 'Repeater Manager',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              routerConfig: AppRouter.createRouter(
                homeRepository: context.read<HomeRepository>(),
              ),
              builder: (context, child) {
                final routedChild = child ?? const SizedBox.shrink();

                return BlocBuilder<ConnectivityCubit, ConnectivityState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Positioned.fill(child: routedChild),
                        if (state.hasCheckedConnection && !state.isConnected)
                          const Positioned.fill(
                            child: _ConnectivityBlockingOverlay(),
                          ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ConnectivityBlockingOverlay extends StatelessWidget {
  const _ConnectivityBlockingOverlay();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          const Positioned.fill(
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black54,
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 12,
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 72,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No internet connection',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reconnect to continue using the app. All navigation and screen interaction stay blocked until the connection returns.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
