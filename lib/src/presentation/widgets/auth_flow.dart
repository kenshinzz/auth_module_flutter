import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/auth_providers.dart';
import '../../core/theme/auth_theme.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../screens/login_screen.dart';

/// A widget that manages the complete authentication flow.
///
/// This widget automatically shows the login screen when the user is not
/// authenticated, and shows the [destination] widget when authenticated.
///
/// Usage:
/// ```dart
/// AuthFlow(
///   destination: HomeScreen(),
///   // Optional customization
///   loginTitle: 'Welcome Back',
///   loginSubtitle: 'Sign in to continue',
/// )
/// ```
///
/// For apps that need more control, you can use [AuthFlowBuilder] instead.
class AuthFlow extends ConsumerStatefulWidget {
  /// The widget to show after successful login.
  final Widget destination;

  /// Builder for the destination widget that receives the logged-in user.
  /// If provided, this takes precedence over [destination].
  final Widget Function(BuildContext context, User user)? destinationBuilder;

  /// Custom title for the login screen.
  final String? loginTitle;

  /// Custom subtitle for the login screen.
  final String? loginSubtitle;

  /// Callback invoked after successful login (before navigating to destination).
  /// Useful for analytics, logging, or additional setup.
  final void Function(User user)? onLoginSuccess;

  /// Whether to check for existing authentication on startup.
  /// Defaults to true.
  final bool checkAuthOnStartup;

  /// Widget to show while checking authentication status.
  /// Defaults to a centered CircularProgressIndicator.
  final Widget? loadingWidget;

  /// Custom theme for auth screens.
  final AuthTheme? theme;

  const AuthFlow({
    super.key,
    required this.destination,
    this.destinationBuilder,
    this.loginTitle,
    this.loginSubtitle,
    this.onLoginSuccess,
    this.checkAuthOnStartup = true,
    this.loadingWidget,
    this.theme,
  });

  @override
  ConsumerState<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends ConsumerState<AuthFlow> {
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.checkAuthOnStartup) {
      _checkExistingAuth();
    } else {
      setState(() => _isCheckingAuth = false);
    }
  }

  Future<void> _checkExistingAuth() async {
    final authRepo = ref.read(authRepositoryProvider);
    final isLoggedIn = await authRepo.isLoggedIn();

    if (isLoggedIn) {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        setState(() {
          _isAuthenticated = true;
          _currentUser = user;
          _isCheckingAuth = false;
        });
        return;
      }
    }

    setState(() => _isCheckingAuth = false);
  }

  void _handleLoginSuccess(User user) {
    widget.onLoginSuccess?.call(user);
    setState(() {
      _isAuthenticated = true;
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return widget.loadingWidget ??
          const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isAuthenticated && _currentUser != null) {
      if (widget.destinationBuilder != null) {
        return widget.destinationBuilder!(context, _currentUser!);
      }
      return widget.destination;
    }

    return LoginScreen(
      title: widget.loginTitle,
      subtitle: widget.loginSubtitle,
      onLoginSuccess: _handleLoginSuccess,
      theme: widget.theme,
    );
  }
}

/// A more flexible builder-based approach for authentication flow.
///
/// This gives you full control over what to render in each state.
///
/// Usage:
/// ```dart
/// AuthFlowBuilder(
///   authenticated: (context, user) => HomeScreen(user: user),
///   unauthenticated: (context, onLoginSuccess) => LoginScreen(
///     onLoginSuccess: onLoginSuccess,
///   ),
/// )
/// ```
class AuthFlowBuilder extends ConsumerStatefulWidget {
  /// Builder for the authenticated state.
  final Widget Function(BuildContext context, User user) authenticated;

  /// Builder for the unauthenticated state.
  /// The [onLoginSuccess] callback should be called when login succeeds.
  final Widget Function(
    BuildContext context,
    void Function(User user) onLoginSuccess,
  )
  unauthenticated;

  /// Builder for the loading state (while checking auth).
  final Widget Function(BuildContext context)? loading;

  /// Whether to check for existing authentication on startup.
  final bool checkAuthOnStartup;

  const AuthFlowBuilder({
    super.key,
    required this.authenticated,
    required this.unauthenticated,
    this.loading,
    this.checkAuthOnStartup = true,
  });

  @override
  ConsumerState<AuthFlowBuilder> createState() => _AuthFlowBuilderState();
}

class _AuthFlowBuilderState extends ConsumerState<AuthFlowBuilder> {
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.checkAuthOnStartup) {
      _checkExistingAuth();
    } else {
      setState(() => _isCheckingAuth = false);
    }
  }

  Future<void> _checkExistingAuth() async {
    final authRepo = ref.read(authRepositoryProvider);
    final isLoggedIn = await authRepo.isLoggedIn();

    if (isLoggedIn) {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        setState(() {
          _isAuthenticated = true;
          _currentUser = user;
          _isCheckingAuth = false;
        });
        return;
      }
    }

    setState(() => _isCheckingAuth = false);
  }

  void _handleLoginSuccess(User user) {
    setState(() {
      _isAuthenticated = true;
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return widget.loading?.call(context) ??
          const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isAuthenticated && _currentUser != null) {
      return widget.authenticated(context, _currentUser!);
    }

    return widget.unauthenticated(context, _handleLoginSuccess);
  }
}

/// Provides logout functionality and auth state to descendant widgets.
///
/// Wrap your authenticated screens with this to easily access logout.
///
/// Usage:
/// ```dart
/// AuthScope(
///   user: user,
///   onLogout: () => setState(() => _isAuthenticated = false),
///   child: HomeScreen(),
/// )
/// ```
///
/// In child widgets:
/// ```dart
/// AuthScope.of(context).logout();
/// ```
class AuthScope extends InheritedWidget {
  final User user;
  final VoidCallback _onLogout;
  final AuthRepository _authRepository;

  const AuthScope({
    super.key,
    required this.user,
    required VoidCallback onLogout,
    required AuthRepository authRepository,
    required super.child,
  }) : _onLogout = onLogout,
       _authRepository = authRepository;

  /// Get the AuthScope from the widget tree.
  static AuthScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthScope>();
  }

  /// Get the AuthScope from the widget tree.
  /// Throws if not found.
  static AuthScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No AuthScope found in context');
    return scope!;
  }

  /// Logout the current user and trigger the onLogout callback.
  Future<void> logout() async {
    await _authRepository.logout();
    _onLogout();
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) {
    return user != oldWidget.user;
  }
}
