import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';

class AppResponsivePage extends StatelessWidget {
  const AppResponsivePage({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.maxContentWidth = AppBreakpoints.contentMaxWidth,
    this.padding = const EdgeInsets.all(16),
    this.scrollable = true,
    this.backgroundColor,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final builder = width >= AppBreakpoints.tablet
            ? (width >= AppBreakpoints.desktop
                ? desktop ?? tablet ?? mobile
                : tablet ?? mobile)
            : mobile;

        final content = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: padding,
            child: builder(context),
          ),
        );

        final alignedContent = Align(
          alignment: Alignment.topCenter,
          child: content,
        );

        final wrappedContent = scrollable
            ? SingleChildScrollView(child: alignedContent)
            : alignedContent;

        return ColoredBox(
          color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          child: wrappedContent,
        );
      },
    );
  }
}
