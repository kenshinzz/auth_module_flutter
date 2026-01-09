import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'src/core/l10n/generated/auth_l10n.dart';
import 'src/core/network/api_client.dart';
import 'src/core/theme/auth_theme.dart';
import 'src/data/datasources/auth_remote_datasource.dart';
import 'src/data/repositories/auth_repository_impl.dart';
import 'src/domain/repositories/auth_repository.dart';
import 'src/presentation/viewmodels/login_viewmodel.dart';

// Core
export 'src/core/errors/failures.dart';
export 'src/core/l10n/generated/auth_l10n.dart';
export 'src/core/localization/auth_localizations.dart';
export 'src/core/network/api_client.dart' show ApiException, ApiExceptionType;
export 'src/core/theme/auth_theme.dart';

// Router
export 'src/core/router/auth_router.dart';
export 'src/core/router/auth_routes.dart';

// Domain
export 'src/domain/entities/user.dart';
export 'src/domain/repositories/auth_repository.dart';

// Presentation
export 'src/presentation/screens/login_screen.dart';
export 'src/presentation/viewmodels/login_viewmodel.dart';
export 'src/presentation/widgets/auth_flow.dart';
export 'src/presentation/widgets/auth_text_field.dart';

/// Configuration class for the Auth Module.
///
/// Usage:
/// ```dart
/// void main() {
///   AuthModule.configure(
///     baseUrl: 'https://api.example.com',
///     loginEndpoint: '/auth/login',
///     theme: AuthTheme(
///       primaryColor: Colors.indigo,
///       fontFamily: 'Poppins',
///     ),
///   );
///
///   runApp(
///     MultiProvider(
///       providers: AuthModule.providers,
///       child: MaterialApp(
///         localizationsDelegates: AuthL10n.localizationsDelegates,
///         supportedLocales: AuthL10n.supportedLocales,
///         // ...
///       ),
///     ),
///   );
/// }
/// ```
class AuthModule {
  static AuthModule? _instance;

  final String baseUrl;
  final String loginEndpoint;
  final AuthTheme theme;
  final AuthRepository _authRepository;

  AuthModule._({
    required this.baseUrl,
    required this.loginEndpoint,
    required this.theme,
  }) : _authRepository = _createAuthRepository(baseUrl, loginEndpoint);

  static AuthRepository _createAuthRepository(
    String baseUrl,
    String loginEndpoint,
  ) {
    final apiClient = ApiClient(baseUrl: baseUrl);
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    final remoteDataSource = AuthRemoteDataSourceImpl(
      apiClient: apiClient,
      loginEndpoint: loginEndpoint,
    );
    return AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      secureStorage: secureStorage,
      apiClient: apiClient,
    );
  }

  /// Configure the Auth Module with your API settings.
  ///
  /// Must be called before using [providers] or [instance].
  ///
  /// Parameters:
  /// - [baseUrl]: The base URL for your API.
  /// - [loginEndpoint]: The endpoint for login (defaults to '/auth/login').
  /// - [theme]: Custom theme for auth screens (colors, fonts, styling).
  static void configure({
    required String baseUrl,
    String loginEndpoint = '/auth/login',
    AuthTheme theme = const AuthTheme(),
  }) {
    _instance = AuthModule._(
      baseUrl: baseUrl,
      loginEndpoint: loginEndpoint,
      theme: theme,
    );
  }

  /// Get the configured AuthModule instance.
  ///
  /// Throws if [configure] has not been called.
  static AuthModule get instance {
    if (_instance == null) {
      throw StateError(
        'AuthModule has not been configured. '
        'Call AuthModule.configure() before accessing instance.',
      );
    }
    return _instance!;
  }

  /// Get the list of providers to use with MultiProvider.
  ///
  /// Example:
  /// ```dart
  /// MultiProvider(
  ///   providers: AuthModule.providers,
  ///   child: MyApp(),
  /// )
  /// ```
  static List<SingleChildWidget> get providers {
    final module = instance;
    return [
      Provider<AuthRepository>.value(value: module._authRepository),
      ChangeNotifierProvider<LoginViewModel>(
        create: (_) => LoginViewModel(authRepository: module._authRepository),
      ),
    ];
  }

  /// Get the AuthRepository instance.
  AuthRepository get authRepository => _authRepository;

  /// Create a new LoginViewModel instance.
  ///
  /// Useful if you need to create a ViewModel outside of the provider tree.
  LoginViewModel createLoginViewModel() {
    return LoginViewModel(authRepository: _authRepository);
  }

  /// Localization delegates for the auth module.
  ///
  /// Add these to your MaterialApp's localizationsDelegates:
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: AuthModule.localizationsDelegates,
  ///   supportedLocales: AuthModule.supportedLocales,
  /// )
  /// ```
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AuthL10n.localizationsDelegates;

  /// Supported locales for the auth module.
  static List<Locale> get supportedLocales => AuthL10n.supportedLocales;

  /// Wrap your app with this widget to provide theme to all auth screens.
  ///
  /// Example:
  /// ```dart
  /// AuthModule.wrap(
  ///   child: MaterialApp(...),
  /// )
  /// ```
  static Widget wrap({required Widget child}) {
    final module = instance;
    return AuthThemeProvider(theme: module.theme, child: child);
  }
}
