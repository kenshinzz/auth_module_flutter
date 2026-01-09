import 'package:flutter/widgets.dart';

import '../l10n/generated/auth_l10n.dart';

// Re-export the generated l10n class and related types
export '../l10n/generated/auth_l10n.dart';

/// Extension to easily access AuthL10n from BuildContext.
///
/// Usage:
/// ```dart
/// // In your widget
/// final l10n = context.authL10n;
/// Text(l10n.signInTitle);
/// ```
extension AuthL10nContext on BuildContext {
  /// Get the AuthL10n instance from the current context.
  ///
  /// Returns null if AuthL10n is not available in the widget tree.
  /// Make sure to add `AuthL10n.localizationsDelegates` to your app's
  /// `localizationsDelegates` and `AuthL10n.supportedLocales` to
  /// `supportedLocales`.
  AuthL10n? get authL10n => AuthL10n.of(this);

  /// Get the AuthL10n instance from the current context.
  ///
  /// Throws if AuthL10n is not available. Use [authL10n] for nullable access.
  AuthL10n get authL10nStrict {
    final l10n = AuthL10n.of(this);
    assert(l10n != null, 'AuthL10n not found. Did you add AuthL10n.delegate?');
    return l10n!;
  }
}

/// Helper class for auth module localization setup.
///
/// Usage in your app:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     ...AuthL10n.localizationsDelegates,
///     // Your other delegates
///   ],
///   supportedLocales: AuthL10n.supportedLocales,
///   // ...
/// )
/// ```
class AuthLocalization {
  AuthLocalization._();

  /// List of supported locales by the auth module.
  static List<Locale> get supportedLocales => AuthL10n.supportedLocales;

  /// List of localization delegates needed for the auth module.
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AuthL10n.localizationsDelegates;

  /// The auth module's localization delegate.
  static LocalizationsDelegate<AuthL10n> get delegate => AuthL10n.delegate;
}
