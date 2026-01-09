import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'src/core/network/api_client.dart';
import 'src/data/datasources/auth_remote_datasource.dart';
import 'src/data/repositories/auth_repository_impl.dart';
import 'src/domain/repositories/auth_repository.dart';
import 'src/presentation/viewmodels/login_viewmodel.dart';

// Core
export 'src/core/errors/failures.dart';

// Domain
export 'src/domain/entities/user.dart';
export 'src/domain/repositories/auth_repository.dart';

// Presentation
export 'src/presentation/screens/login_screen.dart';
export 'src/presentation/viewmodels/login_viewmodel.dart';
export 'src/presentation/widgets/auth_text_field.dart';

/// Configuration class for the Auth Module.
///
/// Usage:
/// ```dart
/// void main() {
///   AuthModule.configure(
///     baseUrl: 'https://api.example.com',
///     loginEndpoint: '/auth/login',
///   );
///
///   runApp(
///     MultiProvider(
///       providers: AuthModule.providers,
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
class AuthModule {
  static AuthModule? _instance;

  final String baseUrl;
  final String loginEndpoint;
  final AuthRepository _authRepository;

  AuthModule._({
    required this.baseUrl,
    required this.loginEndpoint,
  }) : _authRepository = _createAuthRepository(baseUrl, loginEndpoint);

  static AuthRepository _createAuthRepository(String baseUrl, String loginEndpoint) {
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
  static void configure({
    required String baseUrl,
    String loginEndpoint = '/auth/login',
  }) {
    _instance = AuthModule._(
      baseUrl: baseUrl,
      loginEndpoint: loginEndpoint,
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
}
