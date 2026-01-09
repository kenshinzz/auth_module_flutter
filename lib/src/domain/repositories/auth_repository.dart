import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<({User? user, Failure? failure})> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<({bool success, Failure? failure})> logout();

  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();
}
