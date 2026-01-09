# Auth Module

A reusable Flutter authentication module with a simple sign-in screen using MVVM + Clean Architecture pattern.

## Features

- Login screen with email/password
- Remember me functionality
- Forgot password link
- Form validation
- Secure token storage
- MVVM architecture with Provider
- Easy to integrate into any Flutter project

## Installation

### Option 1: Git dependency (Recommended)

Add to your `pubspec.yaml`:

```yaml
dependencies:
  auth_module:
    git:
      url: https://github.com/kenshinzz/auth_module_flutter.git
      ref: main
```

### Option 2: Local path (for development)

```yaml
dependencies:
  auth_module:
    path: ../auth_module
```

## Usage

### 1. Configure the module

In your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auth_module/auth_module.dart';

void main() {
  AuthModule.configure(
    baseUrl: 'https://your-api.com',
    loginEndpoint: '/auth/login',  // optional, defaults to /auth/login
  );

  runApp(
    MultiProvider(
      providers: AuthModule.providers,
      child: MyApp(),
    ),
  );
}
```

### 2. Navigate to LoginScreen

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => LoginScreen(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue',
      onLoginSuccess: (user) {
        // Handle successful login
        Navigator.pushReplacementNamed(context, '/home');
      },
      onForgotPassword: () {
        // Navigate to forgot password
        Navigator.pushNamed(context, '/forgot-password');
      },
    ),
  ),
);
```

### 3. Access user data

```dart
// Get the auth repository
final authRepo = context.read<AuthRepository>();

// Check if logged in
final isLoggedIn = await authRepo.isLoggedIn();

// Get current user
final user = await authRepo.getCurrentUser();

// Logout
await authRepo.logout();
```

## API Requirements

Your login endpoint should accept POST request with:

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

And return:

```json
{
  "id": "123",
  "email": "user@example.com",
  "name": "John Doe",
  "token": "your_jwt_token"
}
```

## Architecture

```
lib/
├── auth_module.dart              # Public API
└── src/
    ├── core/                     # Core utilities
    │   ├── errors/failures.dart
    │   └── network/api_client.dart
    ├── data/                     # Data layer
    │   ├── models/
    │   ├── datasources/
    │   └── repositories/
    ├── domain/                   # Domain layer
    │   ├── entities/
    │   └── repositories/
    └── presentation/             # Presentation layer (MVVM)
        ├── viewmodels/
        ├── screens/
        └── widgets/
```

## License

MIT License
