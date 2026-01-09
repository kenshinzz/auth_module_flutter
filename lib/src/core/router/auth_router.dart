import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/auth_theme.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/screens/login_screen.dart';

/// Route paths for authentication screens.
class AuthPaths {
  /// Login screen path
  static const String login = '/login';

  AuthPaths._();
}

/// Configuration for the AuthRouter.
///
/// Example:
/// ```dart
/// AuthRouterConfig(
///   loginPath: '/login',
///   homePath: '/home',
///   loginTitle: 'Welcome Back',
///   loginSubtitle: 'Sign in to continue',
///   publicPaths: ['/about', '/terms'],
///   theme: AuthTheme.dark,
/// )
/// ```
class AuthRouterConfig {
  /// Path to the login screen. Defaults to '/login'.
  final String loginPath;

  /// Path to redirect after successful login. Required.
  final String homePath;

  /// Custom title for the login screen.
  /// Overrides the localization title if provided.
  final String? loginTitle;

  /// Custom subtitle for the login screen.
  /// Overrides the localization subtitle if provided.
  final String? loginSubtitle;

  /// Paths that don't require authentication.
  /// Login path is automatically included.
  final List<String> publicPaths;

  /// Callback after successful login (for analytics, etc.)
  final void Function(User user)? onLoginSuccess;

  /// Callback after logout (for analytics, cleanup, etc.)
  final VoidCallback? onLogout;

  /// Custom theme for auth screens.
  /// If null, uses AuthModule.theme or defaults.
  final AuthTheme? theme;

  const AuthRouterConfig({
    this.loginPath = '/login',
    required this.homePath,
    this.loginTitle,
    this.loginSubtitle,
    this.publicPaths = const [],
    this.onLoginSuccess,
    this.onLogout,
    this.theme,
  });

  /// Check if a path is public (doesn't require authentication).
  bool isPublicPath(String path) {
    if (path == loginPath) return true;

    // Check user-defined public paths
    return publicPaths.contains(path) ||
        publicPaths.any((p) => path.startsWith(p));
  }
}

/// Main class for integrating authentication with GoRouter.
///
/// Usage:
/// ```dart
/// // 1. Create the AuthRouter instance
/// final authRouter = AuthRouter(
///   config: AuthRouterConfig(
///     homePath: '/home',
///     loginTitle: 'Welcome',
///   ),
///   authRepository: AuthModule.instance.authRepository,
/// );
///
/// // 2. Create your GoRouter with auth integration
/// final router = GoRouter(
///   initialLocation: '/home',
///   refreshListenable: authRouter,  // Refresh on auth state changes
///   redirect: authRouter.redirect,   // Auth guard
///   routes: [
///     ...authRouter.routes,          // Auth routes
///     GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
///   ],
/// );
///
/// // 3. Logout from anywhere
/// await authRouter.logout(context);
/// ```
class AuthRouter extends ChangeNotifier {
  final AuthRouterConfig config;
  final AuthRepository _authRepository;

  bool _isAuthenticated = false;
  bool _isInitialized = false;
  User? _currentUser;

  AuthRouter({required this.config, required AuthRepository authRepository})
    : _authRepository = authRepository {
    _init();
  }

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _isAuthenticated;

  /// Whether the auth state has been initialized.
  bool get isInitialized => _isInitialized;

  /// The currently authenticated user, if any.
  User? get currentUser => _currentUser;

  /// Initialize auth state by checking stored credentials.
  Future<void> _init() async {
    _isAuthenticated = await _authRepository.isLoggedIn();
    if (_isAuthenticated) {
      _currentUser = await _authRepository.getCurrentUser();
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Get the authentication routes to add to your GoRouter.
  List<RouteBase> get routes => [
    GoRoute(
      path: config.loginPath,
      name: 'auth-login',
      builder: (context, state) => LoginScreen(
        title: config.loginTitle,
        subtitle: config.loginSubtitle,
        onLoginSuccess: (user) => _handleLoginSuccess(context, user),
        theme: config.theme,
      ),
    ),
  ];

  /// Redirect function for GoRouter.
  ///
  /// Add this to your GoRouter's redirect parameter:
  /// ```dart
  /// GoRouter(
  ///   redirect: authRouter.redirect,
  ///   ...
  /// )
  /// ```
  String? redirect(BuildContext context, GoRouterState state) {
    // Don't redirect until initialized
    if (!_isInitialized) return null;

    final isGoingToLogin = state.matchedLocation == config.loginPath;
    final isPublicPath = config.isPublicPath(state.matchedLocation);

    // If not authenticated and trying to access protected route
    if (!_isAuthenticated && !isPublicPath) {
      // Save the intended destination for redirect after login
      return '${config.loginPath}?redirect=${Uri.encodeComponent(state.matchedLocation)}';
    }

    // If authenticated and trying to access login
    if (_isAuthenticated && isGoingToLogin) {
      // Check if there's a redirect parameter
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null) {
        return Uri.decodeComponent(redirect);
      }
      return config.homePath;
    }

    return null;
  }

  /// Handle successful login.
  void _handleLoginSuccess(BuildContext context, User user) {
    _isAuthenticated = true;
    _currentUser = user;
    config.onLoginSuccess?.call(user);
    notifyListeners();

    // Check for redirect parameter
    final uri = GoRouterState.of(context).uri;
    final redirect = uri.queryParameters['redirect'];
    if (redirect != null) {
      context.go(Uri.decodeComponent(redirect));
    } else {
      context.go(config.homePath);
    }
  }

  /// Logout the current user and navigate to login.
  ///
  /// Call this from anywhere in your app:
  /// ```dart
  /// await authRouter.logout(context);
  /// ```
  Future<void> logout(BuildContext context) async {
    await _authRepository.logout();
    _isAuthenticated = false;
    _currentUser = null;
    config.onLogout?.call();
    notifyListeners();

    if (context.mounted) {
      context.go(config.loginPath);
    }
  }

  /// Refresh auth state (call after external auth changes).
  Future<void> refresh() async {
    _isAuthenticated = await _authRepository.isLoggedIn();
    if (_isAuthenticated) {
      _currentUser = await _authRepository.getCurrentUser();
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }
}

/// Riverpod provider for AuthRouter.
///
/// This must be overridden in your ProviderScope with the actual AuthRouter instance.
///
/// Example:
/// ```dart
/// ProviderScope(
///   overrides: [
///     authRouterProvider.overrideWithValue(authRouter),
///   ],
///   child: MyApp(),
/// )
/// ```
final authRouterProvider = Provider<AuthRouter>((ref) {
  throw UnimplementedError(
    'authRouterProvider must be overridden. '
    'Override it in your ProviderScope with your AuthRouter instance.',
  );
});

/// Extension for easy access to AuthRouter from WidgetRef.
extension AuthRouterRef on WidgetRef {
  /// Get the AuthRouter.
  AuthRouter get authRouter => read(authRouterProvider);

  /// Logout and navigate to login screen.
  Future<void> logout(BuildContext context) => authRouter.logout(context);
}

/// Extension for easy access to AuthRouter from context using Riverpod.
extension AuthRouterContext on BuildContext {
  /// Get the AuthRouter from Riverpod.
  ///
  /// Requires a ProviderScope ancestor with authRouterProvider overridden.
  AuthRouter get authRouter {
    final container = ProviderScope.containerOf(this);
    return container.read(authRouterProvider);
  }

  /// Logout and navigate to login screen.
  ///
  /// Usage:
  /// ```dart
  /// await context.logout();
  /// ```
  Future<void> logout() => authRouter.logout(this);
}
