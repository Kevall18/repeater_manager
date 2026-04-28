class AppValidators {
  const AppValidators._();

  static String? requiredTrimmed(String? value,
      {String fieldName = 'This field'}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email cannot be empty';
    }

    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? password(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Password cannot be empty';
    }

    if (trimmed.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Confirm password cannot be empty';
    }

    if (trimmed != password.trim()) {
      return 'Passwords do not match';
    }

    return null;
  }
}
