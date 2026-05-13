import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/app_scaffold/app_scaffold.dart';
import '../../../commons/app_text/app_text.dart';
import '../../../commons/responsive/app_responsive_page.dart';
import '../../../modules/auth/bloc/auth_cubit.dart';
import '../../../modules/auth/bloc/auth_state.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Repeater exam fee receipt',
      actions: const [
        const _ProfileMenuButton(),
      ],
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, _) {
          return AppResponsivePage(
            mobile: (context) => _buildContent(context, axis: Axis.vertical),
            tablet: (context) => _buildContent(context, axis: Axis.horizontal),
            desktop: (context) => _buildContent(context, axis: Axis.horizontal),
            scrollable: true,
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required Axis axis,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHorizontal = axis == Axis.horizontal;

    final modules = <_DashboardModule>[
      _DashboardModule(
        icon: Icons.receipt_long,
        title: 'Create Receipt',
        subtitle: 'Add a new student receipt',
        onTap: () => context.push('/receipts/create'),
      ),
      _DashboardModule(
        icon: Icons.list_alt,
        title: 'View Receipts',
        subtitle: 'Browse receipts by year and department',
        onTap: () => context.push('/receipts'),
      ),
      _DashboardModule(
        icon: Icons.calendar_today,
        title: 'Day Statement',
        subtitle: 'Daily collection summary',
        onTap: () => context.push('/receipts/day'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Municipal College Upleta',
            style: AppText.headingLarge(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            'Repeater exam fee receipts - organized by year',
            style: AppText.bodyMedium(color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: isHorizontal ? 22 : 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 1100
                  ? 4
                  : width >= 760
                      ? 3
                      : width >= 500
                          ? 2
                          : 1;
              final mainAxisExtent = width >= 1100
                  ? 160.0
                  : width >= 760
                      ? 152.0
                      : width >= 500
                          ? 144.0
                          : 132.0;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modules.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: mainAxisExtent,
                ),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return _ModuleTile(
                    icon: module.icon,
                    title: module.title,
                    subtitle: module.subtitle,
                    onTap: module.onTap,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardModule {
  const _DashboardModule({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 26, color: colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMedium(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ProfileAction { logout }

class _ProfileMenuButton extends StatelessWidget {
  const _ProfileMenuButton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final email = authState.user?.email ?? 'No email';

        return PopupMenuButton<_ProfileAction>(
          tooltip: 'Profile',
          icon: const Icon(Icons.account_circle_outlined),
          onSelected: (value) {
            if (value == _ProfileAction.logout) {
              context.read<AuthCubit>().signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<_ProfileAction>(
              enabled: false,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Text(
                  email,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMedium(color: colorScheme.onSurface),
                ),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<_ProfileAction>(
              value: _ProfileAction.logout,
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
