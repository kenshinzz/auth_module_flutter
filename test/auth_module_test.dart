import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auth_module/auth_module.dart';

void main() {
  group('User', () {
    group('when created with required fields only', () {
      const user = User(id: '1', email: 'test@example.com');

      test('should have the correct id', () {
        expect(user.id, '1');
      });

      test('should have the correct email', () {
        expect(user.email, 'test@example.com');
      });

      test('should have null name', () {
        expect(user.name, isNull);
      });

      test('should have null token', () {
        expect(user.token, isNull);
      });
    });

    group('when created with all fields', () {
      const user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        token: 'abc123',
      );

      test('should have the correct name', () {
        expect(user.name, 'Test User');
      });

      test('should have the correct token', () {
        expect(user.token, 'abc123');
      });
    });

    group('equality', () {
      test('should be equal when id and email match', () {
        const user1 = User(id: '1', email: 'test@example.com');
        const user2 = User(id: '1', email: 'test@example.com');

        expect(user1, equals(user2));
      });

      test('should not be equal when id differs', () {
        const user1 = User(id: '1', email: 'test@example.com');
        const user2 = User(id: '2', email: 'test@example.com');

        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when email differs', () {
        const user1 = User(id: '1', email: 'test@example.com');
        const user2 = User(id: '1', email: 'other@example.com');

        expect(user1, isNot(equals(user2)));
      });
    });
  });

  group('Failure', () {
    group('AuthFailure', () {
      test('should have default message when not provided', () {
        const failure = AuthFailure();
        expect(failure.message, 'Authentication failed');
      });

      test('should have custom message when provided', () {
        const failure = AuthFailure('Invalid credentials');
        expect(failure.message, 'Invalid credentials');
      });
    });

    group('ServerFailure', () {
      test('should have default message when not provided', () {
        const failure = ServerFailure();
        expect(failure.message, 'Server error occurred');
      });

      test('should have custom message when provided', () {
        const failure = ServerFailure('Internal server error');
        expect(failure.message, 'Internal server error');
      });
    });

    group('NetworkFailure', () {
      test('should have default message when not provided', () {
        const failure = NetworkFailure();
        expect(failure.message, 'Network error occurred');
      });

      test('should have custom message when provided', () {
        const failure = NetworkFailure('No internet connection');
        expect(failure.message, 'No internet connection');
      });
    });

    group('ValidationFailure', () {
      test('should have default message when not provided', () {
        const failure = ValidationFailure();
        expect(failure.message, 'Validation failed');
      });

      test('should have custom message when provided', () {
        const failure = ValidationFailure('Email is invalid');
        expect(failure.message, 'Email is invalid');
      });
    });

    group('CacheFailure', () {
      test('should have default message when not provided', () {
        const failure = CacheFailure();
        expect(failure.message, 'Cache error occurred');
      });

      test('should have custom message when provided', () {
        const failure = CacheFailure('Failed to read cache');
        expect(failure.message, 'Failed to read cache');
      });
    });

    group('equality', () {
      test('should be equal when type and message match', () {
        const failure1 = AuthFailure('error');
        const failure2 = AuthFailure('error');

        expect(failure1, equals(failure2));
      });

      test('should not be equal when message differs', () {
        const failure1 = AuthFailure('error');
        const failure2 = AuthFailure('different');

        expect(failure1, isNot(equals(failure2)));
      });
    });
  });

  group('AuthTheme', () {
    group('when created with defaults', () {
      const theme = AuthTheme();

      test('should have blue as primary color', () {
        expect(theme.primaryColor, Colors.blue);
      });

      test('should have red as error color', () {
        expect(theme.errorColor, Colors.red);
      });

      test('should have 8 as input border radius', () {
        expect(theme.inputBorderRadius, 8);
      });

      test('should have 8 as button border radius', () {
        expect(theme.buttonBorderRadius, 8);
      });

      test('should have 50 as button height', () {
        expect(theme.buttonHeight, 50);
      });

      test('should have 24 padding on all sides', () {
        expect(theme.contentPadding, const EdgeInsets.all(24));
      });

      test('should have 400 as max form width', () {
        expect(theme.maxFormWidth, 400);
      });

      test('should have 16 as element spacing', () {
        expect(theme.elementSpacing, 16);
      });
    });

    group('when created with custom values', () {
      const theme = AuthTheme(
        primaryColor: Colors.indigo,
        backgroundColor: Colors.white,
        inputBorderRadius: 12,
        buttonBorderRadius: 16,
        buttonHeight: 52,
        fontFamily: 'Poppins',
      );

      test('should have the custom primary color', () {
        expect(theme.primaryColor, Colors.indigo);
      });

      test('should have the custom background color', () {
        expect(theme.backgroundColor, Colors.white);
      });

      test('should have the custom input border radius', () {
        expect(theme.inputBorderRadius, 12);
      });

      test('should have the custom button border radius', () {
        expect(theme.buttonBorderRadius, 16);
      });

      test('should have the custom button height', () {
        expect(theme.buttonHeight, 52);
      });

      test('should have the custom font family', () {
        expect(theme.fontFamily, 'Poppins');
      });
    });

    group('.copyWith()', () {
      const original = AuthTheme(
        primaryColor: Colors.blue,
        inputBorderRadius: 8,
        buttonHeight: 50,
      );

      test('should create new theme with updated primary color', () {
        final copied = original.copyWith(primaryColor: Colors.green);

        expect(copied.primaryColor, Colors.green);
      });

      test('should preserve unchanged values', () {
        final copied = original.copyWith(primaryColor: Colors.green);

        expect(copied.inputBorderRadius, 8);
        expect(copied.buttonHeight, 50);
      });

      test('should allow updating multiple values', () {
        final copied = original.copyWith(
          primaryColor: Colors.green,
          buttonHeight: 60,
        );

        expect(copied.primaryColor, Colors.green);
        expect(copied.buttonHeight, 60);
      });
    });

    group('.light', () {
      const theme = AuthTheme.light;

      test('should have white background', () {
        expect(theme.backgroundColor, Colors.white);
      });

      test('should have dark title color', () {
        expect(theme.titleColor, const Color(0xFF212121));
      });

      test('should have blue primary color', () {
        expect(theme.primaryColor, const Color(0xFF2196F3));
      });

      test('should have white button text color', () {
        expect(theme.buttonTextColor, Colors.white);
      });
    });

    group('.dark', () {
      const theme = AuthTheme.dark;

      test('should have dark background', () {
        expect(theme.backgroundColor, const Color(0xFF121212));
      });

      test('should have white title color', () {
        expect(theme.titleColor, const Color(0xFFFFFFFF));
      });

      test('should have light blue primary color', () {
        expect(theme.primaryColor, const Color(0xFF64B5F6));
      });

      test('should have dark input background', () {
        expect(theme.inputBackgroundColor, const Color(0xFF1E1E1E));
      });
    });

    group('.resolve()', () {
      group('when brightness is light', () {
        test('should return light theme by default', () {
          final theme = AuthTheme.resolve(brightness: Brightness.light);

          expect(theme.backgroundColor, AuthTheme.light.backgroundColor);
        });

        test('should return custom light theme when provided', () {
          const customLight = AuthTheme(primaryColor: Colors.pink);

          final theme = AuthTheme.resolve(
            brightness: Brightness.light,
            lightTheme: customLight,
          );

          expect(theme.primaryColor, Colors.pink);
        });
      });

      group('when brightness is dark', () {
        test('should return dark theme by default', () {
          final theme = AuthTheme.resolve(brightness: Brightness.dark);

          expect(theme.backgroundColor, AuthTheme.dark.backgroundColor);
        });

        test('should return custom dark theme when provided', () {
          const customDark = AuthTheme(primaryColor: Colors.purple);

          final theme = AuthTheme.resolve(
            brightness: Brightness.dark,
            darkTheme: customDark,
          );

          expect(theme.primaryColor, Colors.purple);
        });
      });
    });
  });

  group('AuthThemeMode', () {
    test('should have three values', () {
      expect(AuthThemeMode.values.length, 3);
    });

    test('should include light mode', () {
      expect(AuthThemeMode.values, contains(AuthThemeMode.light));
    });

    test('should include dark mode', () {
      expect(AuthThemeMode.values, contains(AuthThemeMode.dark));
    });

    test('should include system mode', () {
      expect(AuthThemeMode.values, contains(AuthThemeMode.system));
    });
  });

  group('AuthThemeData', () {
    group('when created with defaults', () {
      const themeData = AuthThemeData();

      test('should use AuthTheme.light as light theme', () {
        expect(themeData.lightTheme.primaryColor, AuthTheme.light.primaryColor);
      });

      test('should use AuthTheme.dark as dark theme', () {
        expect(themeData.darkTheme.primaryColor, AuthTheme.dark.primaryColor);
      });

      test('should use system as theme mode', () {
        expect(themeData.themeMode, AuthThemeMode.system);
      });
    });

    group('when created with custom themes', () {
      const customLight = AuthTheme(primaryColor: Colors.orange);
      const customDark = AuthTheme(primaryColor: Colors.teal);
      const themeData = AuthThemeData(
        lightTheme: customLight,
        darkTheme: customDark,
        themeMode: AuthThemeMode.dark,
      );

      test('should use the custom light theme', () {
        expect(themeData.lightTheme.primaryColor, Colors.orange);
      });

      test('should use the custom dark theme', () {
        expect(themeData.darkTheme.primaryColor, Colors.teal);
      });

      test('should use the specified theme mode', () {
        expect(themeData.themeMode, AuthThemeMode.dark);
      });
    });

    group('.single()', () {
      const theme = AuthTheme(primaryColor: Colors.amber);
      const themeData = AuthThemeData.single(theme);

      test('should use same theme for light mode', () {
        expect(themeData.lightTheme.primaryColor, Colors.amber);
      });

      test('should use same theme for dark mode', () {
        expect(themeData.darkTheme.primaryColor, Colors.amber);
      });

      test('should use light as theme mode', () {
        expect(themeData.themeMode, AuthThemeMode.light);
      });
    });

    group('.resolve()', () {
      const lightTheme = AuthTheme(primaryColor: Colors.red);
      const darkTheme = AuthTheme(primaryColor: Colors.blue);

      group('when mode is light', () {
        const themeData = AuthThemeData(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          themeMode: AuthThemeMode.light,
        );

        test('should return light theme regardless of brightness', () {
          expect(themeData.resolve(Brightness.light).primaryColor, Colors.red);
          expect(themeData.resolve(Brightness.dark).primaryColor, Colors.red);
        });
      });

      group('when mode is dark', () {
        const themeData = AuthThemeData(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          themeMode: AuthThemeMode.dark,
        );

        test('should return dark theme regardless of brightness', () {
          expect(themeData.resolve(Brightness.light).primaryColor, Colors.blue);
          expect(themeData.resolve(Brightness.dark).primaryColor, Colors.blue);
        });
      });

      group('when mode is system', () {
        const themeData = AuthThemeData(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          themeMode: AuthThemeMode.system,
        );

        test('should return light theme when brightness is light', () {
          expect(themeData.resolve(Brightness.light).primaryColor, Colors.red);
        });

        test('should return dark theme when brightness is dark', () {
          expect(themeData.resolve(Brightness.dark).primaryColor, Colors.blue);
        });
      });
    });
  });

  group('AuthThemeProvider', () {
    group('.of()', () {
      testWidgets('should return default theme when no provider exists', (
        tester,
      ) async {
        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedTheme = AuthThemeProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.blue);
      });

      testWidgets('should return theme from provider', (tester) async {
        const customTheme = AuthTheme(primaryColor: Colors.purple);
        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          MaterialApp(
            home: AuthThemeProvider(
              theme: customTheme,
              child: Builder(
                builder: (context) {
                  capturedTheme = AuthThemeProvider.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.purple);
      });
    });

    group('.maybeOf()', () {
      testWidgets('should return null when no provider exists', (tester) async {
        AuthTheme? capturedTheme;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedTheme = AuthThemeProvider.maybeOf(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(capturedTheme, isNull);
      });

      testWidgets('should return theme when provider exists', (tester) async {
        const customTheme = AuthTheme(primaryColor: Colors.teal);
        AuthTheme? capturedTheme;

        await tester.pumpWidget(
          MaterialApp(
            home: AuthThemeProvider(
              theme: customTheme,
              child: Builder(
                builder: (context) {
                  capturedTheme = AuthThemeProvider.maybeOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(capturedTheme?.primaryColor, Colors.teal);
      });
    });

    group('.adaptive()', () {
      const themeData = AuthThemeData(
        lightTheme: AuthTheme(primaryColor: Colors.yellow),
        darkTheme: AuthTheme(primaryColor: Colors.deepPurple),
        themeMode: AuthThemeMode.system,
      );

      testWidgets('should resolve to light theme when brightness is light', (
        tester,
      ) async {
        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.light),
            child: MaterialApp(
              home: AuthThemeProvider.adaptive(
                themeData: themeData,
                child: Builder(
                  builder: (context) {
                    capturedTheme = AuthThemeProvider.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.yellow);
      });

      testWidgets('should resolve to dark theme when brightness is dark', (
        tester,
      ) async {
        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: MaterialApp(
              home: AuthThemeProvider.adaptive(
                themeData: themeData,
                child: Builder(
                  builder: (context) {
                    capturedTheme = AuthThemeProvider.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.deepPurple);
      });
    });
  });

  group('AuthModule', () {
    setUp(() {
      AuthModule.reset();
    });

    tearDown(() {
      AuthModule.reset();
    });

    group('when not configured', () {
      test('should throw StateError when accessing instance', () {
        expect(() => AuthModule.instance, throwsA(isA<StateError>()));
      });

      test('should throw with descriptive error message', () {
        expect(
          () => AuthModule.instance,
          throwsA(
            predicate<StateError>(
              (e) => e.message.contains('AuthModule has not been configured'),
            ),
          ),
        );
      });
    });

    group('.configure()', () {
      test('should create instance with provided baseUrl', () {
        AuthModule.configure(baseUrl: 'https://api.example.com');

        expect(AuthModule.instance.baseUrl, 'https://api.example.com');
      });

      test('should use default login endpoint when not provided', () {
        AuthModule.configure(baseUrl: 'https://api.example.com');

        expect(AuthModule.instance.loginEndpoint, '/auth/login');
      });

      test('should use custom login endpoint when provided', () {
        AuthModule.configure(
          baseUrl: 'https://api.example.com',
          loginEndpoint: '/api/v1/login',
        );

        expect(AuthModule.instance.loginEndpoint, '/api/v1/login');
      });

      test('should store single theme when provided', () {
        const customTheme = AuthTheme(primaryColor: Colors.green);

        AuthModule.configure(
          baseUrl: 'https://api.example.com',
          theme: customTheme,
        );

        expect(AuthModule.instance.theme?.primaryColor, Colors.green);
        expect(AuthModule.instance.themeData, isNull);
      });

      test('should store theme data when provided', () {
        const themeData = AuthThemeData(
          lightTheme: AuthTheme(primaryColor: Colors.orange),
          darkTheme: AuthTheme(primaryColor: Colors.deepOrange),
          themeMode: AuthThemeMode.dark,
        );

        AuthModule.configure(
          baseUrl: 'https://api.example.com',
          themeData: themeData,
        );

        expect(AuthModule.instance.themeData, isNotNull);
        expect(
          AuthModule.instance.themeData?.lightTheme.primaryColor,
          Colors.orange,
        );
        expect(AuthModule.instance.themeData?.themeMode, AuthThemeMode.dark);
      });
    });

    group('.instance', () {
      setUp(() {
        AuthModule.configure(baseUrl: 'https://api.example.com');
      });

      test('should return configured instance', () {
        expect(AuthModule.instance, isNotNull);
      });

      test('should provide access to authRepository', () {
        expect(AuthModule.instance.authRepository, isNotNull);
      });
    });

    group('.createLoginViewModel()', () {
      setUp(() {
        AuthModule.configure(baseUrl: 'https://api.example.com');
      });

      test('should return new instance each time', () {
        final vm1 = AuthModule.instance.createLoginViewModel();
        final vm2 = AuthModule.instance.createLoginViewModel();

        expect(vm1, isNot(same(vm2)));
      });
    });

    group('.providers', () {
      setUp(() {
        AuthModule.configure(baseUrl: 'https://api.example.com');
      });

      test('should return list of providers', () {
        final providers = AuthModule.providers;

        expect(providers, isNotEmpty);
      });

      test('should contain two providers', () {
        final providers = AuthModule.providers;

        expect(providers.length, 2);
      });
    });

    group('.localizationsDelegates', () {
      test('should not be empty', () {
        expect(AuthModule.localizationsDelegates, isNotEmpty);
      });
    });

    group('.supportedLocales', () {
      test('should not be empty', () {
        expect(AuthModule.supportedLocales, isNotEmpty);
      });

      test('should include English', () {
        expect(
          AuthModule.supportedLocales.map((l) => l.languageCode),
          contains('en'),
        );
      });

      test('should include Thai', () {
        expect(
          AuthModule.supportedLocales.map((l) => l.languageCode),
          contains('th'),
        );
      });

      test('should include Japanese', () {
        expect(
          AuthModule.supportedLocales.map((l) => l.languageCode),
          contains('ja'),
        );
      });

      test('should include Chinese', () {
        expect(
          AuthModule.supportedLocales.map((l) => l.languageCode),
          contains('zh'),
        );
      });

      test('should include Spanish', () {
        expect(
          AuthModule.supportedLocales.map((l) => l.languageCode),
          contains('es'),
        );
      });
    });

    group('.reset()', () {
      test('should clear the configured instance', () {
        AuthModule.configure(baseUrl: 'https://api.example.com');
        expect(AuthModule.instance, isNotNull);

        AuthModule.reset();

        expect(() => AuthModule.instance, throwsA(isA<StateError>()));
      });
    });
  });

  group('AuthModule.wrap()', () {
    setUp(() {
      AuthModule.reset();
    });

    tearDown(() {
      AuthModule.reset();
    });

    group('when configured with single theme', () {
      testWidgets('should provide the theme to descendants', (tester) async {
        const customTheme = AuthTheme(primaryColor: Colors.cyan);
        AuthModule.configure(
          baseUrl: 'https://api.example.com',
          theme: customTheme,
        );

        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          AuthModule.wrap(
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  capturedTheme = AuthThemeProvider.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.cyan);
      });
    });

    group('when configured with theme data', () {
      testWidgets('should resolve theme based on brightness', (tester) async {
        const themeData = AuthThemeData(
          lightTheme: AuthTheme(primaryColor: Colors.lime),
          darkTheme: AuthTheme(primaryColor: Colors.indigo),
          themeMode: AuthThemeMode.system,
        );
        AuthModule.configure(
          baseUrl: 'https://api.example.com',
          themeData: themeData,
        );

        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: AuthModule.wrap(
              child: MaterialApp(
                home: Builder(
                  builder: (context) {
                    capturedTheme = AuthThemeProvider.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.indigo);
      });
    });

    group('when configured without theme', () {
      testWidgets('should use default theme', (tester) async {
        AuthModule.configure(baseUrl: 'https://api.example.com');

        late AuthTheme capturedTheme;

        await tester.pumpWidget(
          AuthModule.wrap(
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  capturedTheme = AuthThemeProvider.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(capturedTheme.primaryColor, Colors.blue);
      });
    });
  });
}
