// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthL10nEn extends AuthL10n {
  AuthL10nEn([String locale = 'en']) : super(locale);

  @override
  String get signInTitle => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to continue';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get signInButton => 'Sign In';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get fillAllFields => 'Please fill in all fields correctly';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get unknownError => 'An unexpected error occurred';

  @override
  String get connectionTimeout => 'Connection timeout. Please try again.';
}
