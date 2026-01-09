import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'auth_l10n_en.dart';
import 'auth_l10n_es.dart';
import 'auth_l10n_ja.dart';
import 'auth_l10n_th.dart';
import 'auth_l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AuthL10n
/// returned by `AuthL10n.of(context)`.
///
/// Applications need to include `AuthL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/auth_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthL10n.localizationsDelegates,
///   supportedLocales: AuthL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AuthL10n.supportedLocales
/// property.
abstract class AuthL10n {
  AuthL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthL10n? of(BuildContext context) {
    return Localizations.of<AuthL10n>(context, AuthL10n);
  }

  static const LocalizationsDelegate<AuthL10n> delegate = _AuthL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('th'),
    Locale('zh'),
  ];

  /// Title displayed on the sign in screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get signInTitle;

  /// Subtitle displayed on the sign in screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInSubtitle;

  /// Label for the email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Hint text for the email input field
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// Label for the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Hint text for the password input field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Label for the remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Text for the sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// Error message when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Error message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Error message when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Error message when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Error message when form validation fails
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields correctly'**
  String get fillAllFields;

  /// Error message for authentication failure
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// Error message for network issues
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// Error message for server issues
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// Error message for unknown errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unknownError;

  /// Error message for connection timeout
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please try again.'**
  String get connectionTimeout;
}

class _AuthL10nDelegate extends LocalizationsDelegate<AuthL10n> {
  const _AuthL10nDelegate();

  @override
  Future<AuthL10n> load(Locale locale) {
    return SynchronousFuture<AuthL10n>(lookupAuthL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'th', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthL10nDelegate old) => false;
}

AuthL10n lookupAuthL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AuthL10nEn();
    case 'es':
      return AuthL10nEs();
    case 'ja':
      return AuthL10nJa();
    case 'th':
      return AuthL10nTh();
    case 'zh':
      return AuthL10nZh();
  }

  throw FlutterError(
    'AuthL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
