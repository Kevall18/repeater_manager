import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/app_scaffold/app_scaffold.dart';
import '../../../commons/app_text/app_text.dart';
import '../../../commons/responsive/app_responsive_page.dart';
import '../../../core/cubits/connectivity_cubit.dart';
import '../../../core/cubits/connectivity_state.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../widgets/home_summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Repeater Manager',
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return AppResponsivePage(
            mobile: (context) =>
                _buildContent(context, state, axis: Axis.vertical),
            tablet: (context) =>
                _buildContent(context, state, axis: Axis.horizontal),
            desktop: (context) =>
                _buildContent(context, state, axis: Axis.horizontal),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HomeState state, {
    required Axis axis,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: axis == Axis.vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Foundation is ready',
                  style: AppText.headingLarge(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
                const HomeSummaryCard(
                  title: 'Responsive shell',
                  subtitle:
                      'Every page can now switch layouts with a shared responsive widget.',
                ),
                const SizedBox(height: 12),
                HomeSummaryCard(
                  title: 'Fresh route data',
                  subtitle: state.message,
                ),
                const SizedBox(height: 12),
                BlocBuilder<ConnectivityCubit, ConnectivityState>(
                  builder: (context, connectivityState) {
                    return HomeSummaryCard(
                      title:
                          connectivityState.isConnected ? 'Online' : 'Offline',
                      subtitle: connectivityState.isConnected
                          ? 'Firebase-backed screens can load data normally.'
                          : 'The app is showing an offline-friendly state.',
                      icon: connectivityState.isConnected
                          ? Icons.wifi_rounded
                          : Icons.wifi_off_rounded,
                    );
                  },
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foundation is ready',
                        style:
                            AppText.headingLarge(color: colorScheme.onSurface),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Use modules with repository, bloc/cubit, screen, and widget layers for future work.',
                        style: AppText.bodyMedium(
                            color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      const HomeSummaryCard(
                        title: 'Responsive shell',
                        subtitle:
                            'The common wrapper keeps layouts inside a safe content width.',
                      ),
                      const SizedBox(height: 12),
                      HomeSummaryCard(
                        title: 'Fresh route data',
                        subtitle: state.message,
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<ConnectivityCubit, ConnectivityState>(
                        builder: (context, connectivityState) {
                          return HomeSummaryCard(
                            title: connectivityState.isConnected
                                ? 'Online'
                                : 'Offline',
                            subtitle: connectivityState.isConnected
                                ? 'Firebase-backed screens can load data normally.'
                                : 'The app is showing an offline-friendly state.',
                            icon: connectivityState.isConnected
                                ? Icons.wifi_rounded
                                : Icons.wifi_off_rounded,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
