import 'dart:html' as html;

class StartupSplashGate {
  StartupSplashGate._();

  static const String sessionKey = 'repeater_manager_splash_seen';

  static bool get shouldShowSplash =>
      html.window.sessionStorage[sessionKey] != 'true';

  static void markCompleted() {
    html.window.sessionStorage[sessionKey] = 'true';
  }
}
