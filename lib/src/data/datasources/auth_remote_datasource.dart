import 'package:dio/dio.dart';

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
      final response = await apiClient.post<Map<String, dynamic>>(
        loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data!);
        return (user: user, failure: null);
      }

      return (user: null, failure: const AuthFailure('Invalid credentials'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return (user: null, failure: const NetworkFailure('Connection timeout'));
      }

      if (e.response?.statusCode == 401) {
        return (user: null, failure: const AuthFailure('Invalid email or password'));
      }

      if (e.response?.statusCode == 422) {
        final message = e.response?.data?['message'] as String? ?? 'Validation error';
        return (user: null, failure: ValidationFailure(message));
      }

      return (user: null, failure: ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return (user: null, failure: ServerFailure(e.toString()));
    }
  }
}
