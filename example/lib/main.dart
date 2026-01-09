import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:auth_module/auth_module.dart';

void main() {
  // Configure with a mock/test URL (will fail on actual login, but UI works)
  AuthModule.configure(
    baseUrl: 'https://jsonplaceholder.typicode.com', // fake API for testing
    loginEndpoint: '/posts', // just to avoid 404
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AuthModule.providers,
      child: MaterialApp.router(
        title: 'Auth Module Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: AuthRoutePaths.login,
  routes: [
    // Add auth routes using the helper
    AuthRoutes.loginRoute(
      title: 'Welcome Back',
      subtitle: 'Sign in to your account',
      onLoginSuccess: (context, user) {
        debugPrint('Login success: ${user.email}');
        // Navigate to home after login
        context.go('/home');
      },
      onForgotPassword: (context) {
        debugPrint('Forgot password tapped');
        // Navigate to forgot password screen
        context.push('/forgot-password');
      },
    ),
    // Home screen route
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Forgot password route (placeholder)
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authRepo = context.read<AuthRepository>();
              await authRepo.logout();
              if (context.mounted) {
                context.goToLogin();
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome! You are logged in.'),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email to reset password',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              const AuthTextField(
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Reset password requested');
                  context.pop();
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
