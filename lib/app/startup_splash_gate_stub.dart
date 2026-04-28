class StartupSplashGate {
  StartupSplashGate._();

  static const String sessionKey = 'repeater_manager_splash_seen';

  static bool get shouldShowSplash => true;

  static void markCompleted() {}
}
