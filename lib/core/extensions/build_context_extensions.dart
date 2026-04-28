import 'package:flutter/material.dart';

import '../constants/app_breakpoints.dart';

extension BuildContextX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get width => mediaQuery.size.width;

  bool get isMobile => width < AppBreakpoints.mobile;

  bool get isTablet =>
      width >= AppBreakpoints.mobile && width < AppBreakpoints.tablet;

  bool get isDesktop => width >= AppBreakpoints.tablet;

  bool get isLargeDesktop => width >= AppBreakpoints.desktop;
}
