import 'package:flutter/material.dart';

import '../../../commons/app_text/app_text.dart';

class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppText.headingLarge(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppText.bodyMedium(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
