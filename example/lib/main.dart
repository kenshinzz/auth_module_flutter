import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:auth_module/auth_module.dart';

// Custom light theme for auth module
const _authLightTheme = AuthTheme(
  primaryColor: Color(0xFF6366F1), // Indigo
  backgroundColor: Color(0xFFF8FAFC),
  titleColor: Color(0xFF1E293B),
  subtitleColor: Color(0xFF64748B),
  inputBorderRadius: 12,
  buttonBorderRadius: 12,
  buttonHeight: 52,
);

// Custom dark theme for auth module
const _authDarkTheme = AuthTheme(
  primaryColor: Color(0xFF818CF8), // Lighter indigo for dark mode
  backgroundColor: Color(0xFF0F172A),
  titleColor: Color(0xFFF1F5F9),
  subtitleColor: Color(0xFF94A3B8),
  labelColor: Color(0xFFE2E8F0),
  inputBorderColor: Color(0xFF334155),
  inputBackgroundColor: Color(0xFF1E293B),
  inputBorderRadius: 12,
  buttonBorderRadius: 12,
  buttonHeight: 52,
  secondaryTextColor: Color(0xFF94A3B8),
);

void main() {
  // 1. Configure the auth module (theme will be set dynamically)
  AuthModule.configure(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    loginEndpoint: '/posts',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  // 2. Create AuthRouter with your configuration
  late final AuthRouter authRouter = AuthRouter(
    config: AuthRouterConfig(
      homePath: '/home',
      // Override title/subtitle (optional - uses l10n by default)
      loginTitle: 'Welcome Back',
      loginSubtitle: 'Sign in to your account',
      publicPaths: ['/about', '/terms'],
      onLoginSuccess: (user) => debugPrint('User logged in: ${user.email}'),
      onLogout: () => debugPrint('User logged out'),
    ),
    authRepository: AuthModule.instance.authRepository,
  );

  // 3. Create GoRouter with auth integration
  late final GoRouter router = GoRouter(
    initialLocation: '/home',
    refreshListenable: authRouter,
    redirect: authRouter.redirect,
    routes: [
      ...authRouter.routes,
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => SettingsScreen(
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Resolve auth theme based on current theme mode
    final authThemeData = AuthThemeData(
      lightTheme: _authLightTheme,
      darkTheme: _authDarkTheme,
      themeMode: _themeModeToAuthThemeMode(_themeMode),
    );

    return MultiProvider(
      providers: [
        ...AuthModule.providers,
        ChangeNotifierProvider<AuthRouter>.value(value: authRouter),
      ],
      // Provide auth theme with adaptive light/dark support
      child: AuthThemeProvider.adaptive(
        themeData: authThemeData,
        child: MaterialApp.router(
          title: 'Auth Module Demo',
          debugShowCheckedModeBanner: false,
          // Add auth module's localization delegates
          localizationsDelegates: AuthModule.localizationsDelegates,
          supportedLocales: AuthModule.supportedLocales,
          // Light theme for the app
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          // Dark theme for the app
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          // Use the managed theme mode
          themeMode: _themeMode,
          routerConfig: router,
        ),
      ),
    );
  }

  AuthThemeMode _themeModeToAuthThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AuthThemeMode.light;
      case ThemeMode.dark:
        return AuthThemeMode.dark;
      case ThemeMode.system:
        return AuthThemeMode.system;
    }
  }
}

// =============================================================================
// Example Screens
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('Welcome! You are logged in.', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Try navigating to Profile or Settings,\nthen logout from there.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.authRouter.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          ListTile(
            leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark Mode'),
            subtitle: Text(_getThemeModeLabel(themeMode)),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                onThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('Use System Theme'),
            trailing: Switch(
              value: themeMode == ThemeMode.system,
              onChanged: (value) {
                if (value) {
                  onThemeModeChanged(ThemeMode.system);
                } else {
                  // When disabling system theme, use current effective brightness
                  final brightness = MediaQuery.platformBrightnessOf(context);
                  onThemeModeChanged(
                    brightness == Brightness.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => context.logout(),
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
