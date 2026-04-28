import 'package:flutter/material.dart';

import '../app_text/app_text.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 72,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'No internet connection',
                textAlign: TextAlign.center,
                style: AppText.headingLarge(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 12),
              Text(
                'The app needs an active connection to load fresh Firebase data.',
                textAlign: TextAlign.center,
                style: AppText.bodyMedium(color: colorScheme.onSurfaceVariant),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
