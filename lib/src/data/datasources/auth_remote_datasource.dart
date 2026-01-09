import '../../core/errors/failures.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({UserModel? user, Failure? failure})> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final String loginEndpoint;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    this.loginEndpoint = '/auth/login',
  });

  @override
  Future<({UserModel? user, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.isSuccess && response.data != null) {
        final user = UserModel.fromJson(response.data!);
        return (user: user, failure: null);
      }

      return (user: null, failure: const AuthFailure('Invalid credentials'));
    } on ApiException catch (e) {
      return switch (e.type) {
        ApiExceptionType.connectionTimeout ||
        ApiExceptionType.receiveTimeout =>
          (user: null, failure: const NetworkFailure('Connection timeout')),
        ApiExceptionType.unauthorized =>
          (user: null, failure: const AuthFailure('Invalid email or password')),
        ApiExceptionType.validationError =>
          (user: null, failure: ValidationFailure(e.message)),
        ApiExceptionType.serverError ||
        ApiExceptionType.unknown =>
          (user: null, failure: ServerFailure(e.message)),
      };
    } catch (e) {
      return (user: null, failure: ServerFailure(e.toString()));
    }
  }
}
