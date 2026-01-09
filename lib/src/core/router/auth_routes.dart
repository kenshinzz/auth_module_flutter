import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/user.dart';
import '../../presentation/screens/login_screen.dart';

/// Route paths for the auth module
class AuthRoutePaths {
  static const login = '/login';
  static const forgotPassword = '/forgot-password';

  AuthRoutePaths._();
}

/// Configuration for auth module routes
class AuthRouteConfig {
  /// Callback invoked when login succeeds
  final void Function(BuildContext context, User user)? onLoginSuccess;

  /// Callback invoked when user taps forgot password
  final void Function(BuildContext context)? onForgotPassword;

  /// Custom title for the login screen
  final String? loginTitle;

  /// Custom subtitle for the login screen
  final String? loginSubtitle;

  /// Route to redirect to after successful login (alternative to onLoginSuccess)
  final String? redirectAfterLogin;

  const AuthRouteConfig({
    this.onLoginSuccess,
    this.onForgotPassword,
    this.loginTitle,
    this.loginSubtitle,
    this.redirectAfterLogin,
  });
}

/// Provides GoRouter routes for authentication screens
class AuthRoutes {
  final AuthRouteConfig config;

  AuthRoutes({this.config = const AuthRouteConfig()});

  /// Get the list of GoRoute definitions for auth screens
  List<RouteBase> get routes => [
        GoRoute(
          path: AuthRoutePaths.login,
          name: 'login',
          builder: (context, state) => LoginScreen(
            title: config.loginTitle,
            subtitle: config.loginSubtitle,
            onLoginSuccess: (user) {
              if (config.onLoginSuccess != null) {
                config.onLoginSuccess!(context, user);
              } else if (config.redirectAfterLogin != null) {
                context.go(config.redirectAfterLogin!);
              }
            },
            onForgotPassword: config.onForgotPassword != null
                ? () => config.onForgotPassword!(context)
                : null,
          ),
        ),
      ];

  /// Create a single login route (for adding to existing router)
  static GoRoute loginRoute({
    void Function(BuildContext context, User user)? onLoginSuccess,
    void Function(BuildContext context)? onForgotPassword,
    String? title,
    String? subtitle,
    String? redirectAfterLogin,
  }) {
    return GoRoute(
      path: AuthRoutePaths.login,
      name: 'login',
      builder: (context, state) => LoginScreen(
        title: title,
        subtitle: subtitle,
        onLoginSuccess: (user) {
          if (onLoginSuccess != null) {
            onLoginSuccess(context, user);
          } else if (redirectAfterLogin != null) {
            context.go(redirectAfterLogin);
          }
        },
        onForgotPassword:
            onForgotPassword != null ? () => onForgotPassword(context) : null,
      ),
    );
  }
}

/// Extension for easy navigation to auth routes
extension AuthRouterExtension on BuildContext {
  /// Navigate to login screen
  void goToLogin() => go(AuthRoutePaths.login);

  /// Navigate to login and clear navigation stack
  void goToLoginAndClearStack() => go(AuthRoutePaths.login);

  /// Push login screen onto navigation stack
  void pushLogin() => push(AuthRoutePaths.login);
}
