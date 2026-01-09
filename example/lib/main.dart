import 'package:flutter/material.dart';
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
      child: MaterialApp(
        title: 'Auth Module Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: LoginScreen(
          title: 'Welcome Back',
          subtitle: 'Sign in to your account',
          onLoginSuccess: (user) {
            // Show success dialog
            debugPrint('Login success: ${user.email}');
          },
          onForgotPassword: () {
            debugPrint('Forgot password tapped');
          },
        ),
      ),
    );
  }
}
