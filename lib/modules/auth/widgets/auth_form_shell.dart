import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_extensions.dart';

class AuthFormShell extends StatelessWidget {
  const AuthFormShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 20 : 28),
          child: child,
        ),
      ),
    );
  }
}
