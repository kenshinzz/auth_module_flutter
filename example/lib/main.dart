import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:auth_module/auth_module.dart';

void main() {
  // 1. Configure the auth module with theme
  AuthModule.configure(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    loginEndpoint: '/posts',
    // Custom theme
    theme: const AuthTheme(
      primaryColor: Color(0xFF6366F1), // Indigo
      backgroundColor: Color(0xFFF8FAFC),
      titleColor: Color(0xFF1E293B),
      subtitleColor: Color(0xFF64748B),
      inputBorderRadius: 12,
      buttonBorderRadius: 12,
      buttonHeight: 52,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...AuthModule.providers,
        ChangeNotifierProvider<AuthRouter>.value(value: authRouter),
      ],
      // Wrap with AuthModule.wrap() to provide theme globally
      child: AuthModule.wrap(
        child: MaterialApp.router(
          title: 'Auth Module Demo',
          debugShowCheckedModeBanner: false,
          // Add auth module's localization delegates
          localizationsDelegates: AuthModule.localizationsDelegates,
          supportedLocales: AuthModule.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
            ),
            useMaterial3: true,
          ),
          routerConfig: router,
        ),
      ),
    );
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
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(value: false, onChanged: (_) {}),
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
}
