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
- **Splash screen support**
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

## Quick Start

### Basic Setup (Minimal)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_module/auth_module.dart';

void main() {
  // 1. Configure the auth module
  AuthModule.configure(
    baseUrl: 'https://your-api.com',
    loginEndpoint: '/auth/login',
  );

  // 2. Wrap with ProviderScope
  runApp(
    ProviderScope(
      overrides: AuthModule.providerOverrides,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AuthModule.localizationsDelegates,
      supportedLocales: AuthModule.supportedLocales,
      home: LoginScreen(
        onLoginSuccess: (user) {
          // Navigate to home
        },
      ),
    );
  }
}
```

## Full Setup with GoRouter

For a complete authentication flow with route guards, splash screen, and theme switching:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth_module/auth_module.dart';

// Define your themes
const authLightTheme = AuthTheme(
  primaryColor: Color(0xFF6366F1),
  backgroundColor: Color(0xFFF8FAFC),
  titleColor: Color(0xFF1E293B),
  inputBorderRadius: 12,
  buttonBorderRadius: 12,
);

const authDarkTheme = AuthTheme(
  primaryColor: Color(0xFF818CF8),
  backgroundColor: Color(0xFF0F172A),
  titleColor: Color(0xFFF1F5F9),
  inputBorderRadius: 12,
  buttonBorderRadius: 12,
);

void main() {
  AuthModule.configure(
    baseUrl: 'https://your-api.com',
    loginEndpoint: '/auth/login',
  );

  runApp(
    ProviderScope(
      overrides: AuthModule.providerOverrides,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // Create AuthRouter for route guards
  late final AuthRouter authRouter = AuthRouter(
    config: AuthRouterConfig(
      homePath: '/home',
      publicPaths: ['/splash'],
    ),
    authRepository: AuthModule.instance.authRepository,
  );

  // Create GoRouter with auth integration
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: authRouter,
    redirect: authRouter.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => SplashScreen(
          onInitComplete: () {
            if (authRouter.isAuthenticated) {
              _.go('/home');
            } else {
              _.go('/login');
            }
          },
        ),
      ),
      ...authRouter.routes,
      GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Create theme data for adaptive theming
    final authThemeData = AuthThemeData(
      lightTheme: authLightTheme,
      darkTheme: authDarkTheme,
      themeMode: _themeMode == ThemeMode.dark
          ? AuthThemeMode.dark
          : _themeMode == ThemeMode.light
              ? AuthThemeMode.light
              : AuthThemeMode.system,
    );

    return ProviderScope(
      overrides: [authRouterProvider.overrideWithValue(authRouter)],
      // Use AuthThemeProvider.adaptive for dark/light theme support
      child: AuthThemeProvider.adaptive(
        themeData: authThemeData,
        child: MaterialApp.router(
          localizationsDelegates: AuthModule.localizationsDelegates,
          supportedLocales: AuthModule.supportedLocales,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: _themeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}
```

## Theme Customization

### Option 1: Single Theme

```dart
AuthModule.configure(
  baseUrl: 'https://your-api.com',
  theme: AuthTheme(
    primaryColor: Colors.indigo,
    backgroundColor: Colors.white,
    inputBorderRadius: 12,
    buttonBorderRadius: 12,
  ),
);
```

### Option 2: Adaptive Dark/Light Theme (Recommended)

Use `AuthThemeProvider.adaptive` directly for full control:

```dart
AuthThemeProvider.adaptive(
  themeData: AuthThemeData(
    lightTheme: AuthTheme(
      primaryColor: Colors.indigo,
      backgroundColor: Colors.white,
    ),
    darkTheme: AuthTheme(
      primaryColor: Colors.indigoAccent,
      backgroundColor: Color(0xFF121212),
    ),
    themeMode: AuthThemeMode.system, // or .light, .dark
  ),
  child: MaterialApp(...),
)
```

### Option 3: Using AuthModule.wrap() (Simple)

If you configure `themeData` in `AuthModule.configure()`, you can use the convenience wrapper:

```dart
AuthModule.configure(
  baseUrl: 'https://your-api.com',
  themeData: AuthThemeData(
    lightTheme: AuthTheme.light,
    darkTheme: AuthTheme.dark,
    themeMode: AuthThemeMode.system,
  ),
);

// Then wrap your app
AuthModule.wrap(
  child: MaterialApp(...),
)
```

### All Theme Properties

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
  inputBackgroundColor: Colors.white,
  inputBorderRadius: 12,
  
  // Button
  buttonBackgroundColor: Colors.indigo,
  buttonTextColor: Colors.white,
  buttonBorderRadius: 12,
  buttonHeight: 52,
  
  // Typography
  fontFamily: 'Poppins',
  titleStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  labelColor: Colors.black87,
  
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

## Access User Data

```dart
// Using Riverpod providers
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

// Logout from anywhere using context extension
await context.logout();
```

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

## Splash Screen

Add a splash screen as the initial route to check auth status:

```dart
GoRoute(
  path: '/splash',
  builder: (context, state) => SplashScreen(
    onInitComplete: () {
      if (authRouter.isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    },
  ),
),
```

Make sure to add `/splash` to `publicPaths` in your `AuthRouterConfig`:

```dart
AuthRouterConfig(
  homePath: '/home',
  publicPaths: ['/splash', '/about'],  // Splash doesn't require auth
)
```

## GoRouter Integration

```dart
// 1. Create AuthRouter
final authRouter = AuthRouter(
  config: AuthRouterConfig(
    homePath: '/home',
    loginTitle: 'Welcome',
    publicPaths: ['/splash', '/about', '/terms'],
    theme: AuthTheme.dark,
  ),
  authRepository: AuthModule.instance.authRepository,
);

// 2. Create GoRouter with auth integration
final router = GoRouter(
  initialLocation: '/splash',  // Start with splash screen
  refreshListenable: authRouter,
  redirect: authRouter.redirect,
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, _) => SplashScreen(
        onInitComplete: () {
          if (authRouter.isAuthenticated) {
            context.go('/home');
          } else {
            context.go('/login');
          }
        },
      ),
    ),
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
