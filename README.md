# Auth Module

A reusable Flutter authentication module with a simple sign-in screen using MVVM + Clean Architecture pattern.

## Features

- Login screen with email/password
- Remember me functionality
- Form validation
- Secure token storage
- **Customizable theme** (colors, fonts, styling)
- **Dark/Light mode support** (system, manual)
- **Localization support** (English, Thai, Japanese, Chinese, Spanish)
- MVVM architecture with **Riverpod**
- GoRouter integration with auth guards
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_module/auth_module.dart';

void main() {
  // 1. Configure the auth module
  AuthModule.configure(
    baseUrl: 'https://your-api.com',
    loginEndpoint: '/auth/login',
    // Optional: Custom theme
    theme: AuthTheme(
      primaryColor: Colors.indigo,
      inputBorderRadius: 12,
      buttonBorderRadius: 12,
      fontFamily: 'Poppins',
    ),
  );

  // 2. Wrap with ProviderScope and provide auth overrides
  runApp(
    ProviderScope(
      overrides: AuthModule.providerOverrides,
      child: AuthModule.wrap(
        child: MaterialApp(
          // Add localization support
          localizationsDelegates: AuthModule.localizationsDelegates,
          supportedLocales: AuthModule.supportedLocales,
          // ...
        ),
      ),
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
        Navigator.pushReplacementNamed(context, '/home');
      },
    ),
  ),
);
```

### 3. Access user data

```dart
// Using Riverpod
final authRepo = ref.read(authRepositoryProvider);

// Check if logged in
final isLoggedIn = await authRepo.isLoggedIn();

// Get current user
final user = await authRepo.getCurrentUser();

// Logout
await authRepo.logout();

// Or use the async providers
final isLoggedIn = ref.watch(isLoggedInProvider);
final currentUser = ref.watch(currentUserProvider);
```

## Theme Customization

Customize the look and feel of auth screens:

```dart
AuthTheme(
  // Colors
  primaryColor: Colors.indigo,
  backgroundColor: Colors.white,
  titleColor: Color(0xFF1E293B),
  subtitleColor: Color(0xFF64748B),
  errorColor: Colors.red,
  
  // Input fields
  inputBorderColor: Colors.grey,
  inputFocusedBorderColor: Colors.indigo,
  inputBorderRadius: 12,
  
  // Button
  buttonBackgroundColor: Colors.indigo,
  buttonTextColor: Colors.white,
  buttonBorderRadius: 12,
  buttonHeight: 52,
  
  // Typography
  fontFamily: 'Poppins',
  titleStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  
  // Logo
  logo: Image.asset('assets/logo.png'),
  logoHeight: 80,
)
```

### Preset Themes

```dart
// Light theme (default)
AuthTheme.light

// Dark theme
AuthTheme.dark
```

### Dark/Light Mode Support

Use `AuthThemeData` for automatic dark/light mode switching:

```dart
AuthModule.configure(
  baseUrl: 'https://your-api.com',
  themeData: AuthThemeData(
    lightTheme: AuthTheme(
      primaryColor: Colors.indigo,
      backgroundColor: Colors.white,
      // ... other light theme properties
    ),
    darkTheme: AuthTheme(
      primaryColor: Colors.indigoAccent,
      backgroundColor: Color(0xFF121212),
      // ... other dark theme properties
    ),
    // Theme mode options:
    // - AuthThemeMode.light   : Always use light theme
    // - AuthThemeMode.dark    : Always use dark theme
    // - AuthThemeMode.system  : Follow system setting (default)
    themeMode: AuthThemeMode.system,
  ),
);
```

Make sure to wrap your app with `AuthModule.wrap()`:

```dart
ProviderScope(
  overrides: AuthModule.providerOverrides,
  child: AuthModule.wrap(
    child: MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      // ...
    ),
  ),
)
```

The auth screens will automatically switch themes based on the system brightness setting.

## Localization (l10n)

The auth module uses Flutter's standard localization system with `.arb` files.

### Supported Languages

| Language | Locale |
|----------|--------|
| English | `en` (default) |
| Thai | `th` |
| Japanese | `ja` |
| Chinese (Simplified) | `zh` |
| Spanish | `es` |

### Setup

Add the localization delegates to your app:

```dart
MaterialApp(
  localizationsDelegates: AuthModule.localizationsDelegates,
  supportedLocales: AuthModule.supportedLocales,
  // Or specify specific locales:
  // supportedLocales: [Locale('en'), Locale('th')],
)
```

### Access Localized Strings

```dart
// In your widgets
final l10n = AuthL10n.of(context);
Text(l10n?.signInTitle ?? 'Sign In');
```

### Available Strings

- `signInTitle` - Title on sign in screen
- `signInSubtitle` - Subtitle on sign in screen
- `emailLabel` - Email field label
- `emailHint` - Email field hint
- `passwordLabel` - Password field label
- `passwordHint` - Password field hint
- `rememberMe` - Remember me checkbox label
- `signInButton` - Sign in button text
- `emailInvalid` - Invalid email error
- `passwordTooShort` - Password too short error
- `invalidCredentials` - Invalid credentials error
- `networkError` - Network error message
- `serverError` - Server error message

## GoRouter Integration

```dart
// 1. Create AuthRouter
final authRouter = AuthRouter(
  config: AuthRouterConfig(
    homePath: '/home',
    loginTitle: 'Welcome',
    publicPaths: ['/about', '/terms'],
    theme: AuthTheme.dark,
  ),
  authRepository: AuthModule.instance.authRepository,
);

// 2. Create GoRouter with auth integration
final router = GoRouter(
  initialLocation: '/home',
  refreshListenable: authRouter,
  redirect: authRouter.redirect,
  routes: [
    ...authRouter.routes,
    GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
  ],
);

// 3. Provide authRouter in your ProviderScope
ProviderScope(
  overrides: [
    ...AuthModule.providerOverrides,
    authRouterProvider.overrideWithValue(authRouter),
  ],
  child: MaterialApp.router(routerConfig: router),
)

// 4. Logout from anywhere using context extension
await context.logout();
```

## Riverpod Providers

The module exposes the following Riverpod providers:

```dart
// Auth repository - must be overridden via AuthModule.providerOverrides
final authRepositoryProvider = Provider<AuthRepository>(...);

// Login view model - auto-disposed
final loginViewModelProvider = ChangeNotifierProvider.autoDispose<LoginViewModel>(...);

// Check if logged in
final isLoggedInProvider = FutureProvider.autoDispose<bool>(...);

// Current user
final currentUserProvider = FutureProvider.autoDispose<User?>(...);

// Auth router - must be overridden in your app
final authRouterProvider = Provider<AuthRouter>(...);
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
    ├── core/
    │   ├── errors/failures.dart
    │   ├── l10n/                 # Localization (.arb files)
    │   │   ├── app_en.arb
    │   │   ├── app_th.arb
    │   │   ├── app_ja.arb
    │   │   ├── app_zh.arb
    │   │   ├── app_es.arb
    │   │   └── generated/        # Generated l10n code
    │   ├── network/api_client.dart
    │   ├── providers/auth_providers.dart  # Riverpod providers
    │   ├── router/auth_router.dart
    │   └── theme/auth_theme.dart
    ├── data/
    │   ├── models/
    │   ├── datasources/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   └── repositories/
    └── presentation/
        ├── viewmodels/
        ├── screens/
        └── widgets/
```

## Migration from Provider

If you're upgrading from a previous version that used Provider:

1. Replace `MultiProvider` with `ProviderScope`
2. Replace `AuthModule.providers` with `AuthModule.providerOverrides`
3. Replace `context.read<AuthRepository>()` with `ref.read(authRepositoryProvider)`
4. Replace `Consumer<LoginViewModel>` with `ConsumerWidget` / `ref.watch(loginViewModelProvider)`

## License

MIT License
