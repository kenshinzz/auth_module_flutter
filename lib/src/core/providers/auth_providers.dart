import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../presentation/viewmodels/login_viewmodel.dart';

/// Provider for the AuthRepository.
///
/// This must be overridden at the root ProviderScope with the actual
/// implementation from AuthModule.
///
/// Example:
/// ```dart
/// ProviderScope(
///   overrides: [
///     authRepositoryProvider.overrideWithValue(AuthModule.instance.authRepository),
///   ],
///   child: MyApp(),
/// )
/// ```
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden. '
    'Use AuthModule.providerOverrides or override it in your ProviderScope.',
  );
});

/// Provider for the LoginViewModel.
///
/// This is a [StateNotifierProvider] that manages the login state.
/// It automatically disposes when no longer needed.
final loginViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginViewModel>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return LoginViewModel(authRepository: authRepository);
    });

/// Provider for checking if user is logged in.
///
/// Returns a [Future<bool>] indicating the current authentication status.
final isLoggedInProvider = FutureProvider.autoDispose<bool>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.isLoggedIn();
});

/// Provider for the current user.
///
/// Returns a [Future<User?>] with the current user, or null if not logged in.
final currentUserProvider = FutureProvider.autoDispose((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final isLoggedIn = await authRepository.isLoggedIn();
  if (!isLoggedIn) return null;
  return authRepository.getCurrentUser();
});
