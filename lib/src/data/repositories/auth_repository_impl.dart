import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/errors/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final ApiClient apiClient;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _rememberMeKey = 'remember_me';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    required this.apiClient,
  });

  @override
  Future<({User? user, Failure? failure})> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final result = await remoteDataSource.login(
      email: email,
      password: password,
    );

    if (result.failure != null) {
      return (user: null, failure: result.failure);
    }

    final user = result.user!;

    if (user.token != null) {
      apiClient.setAuthToken(user.token!);

      if (rememberMe) {
        await secureStorage.write(key: _tokenKey, value: user.token);
        await secureStorage.write(key: _userKey, value: jsonEncode(UserModel(
          id: user.id,
          email: user.email,
          name: user.name,
          token: user.token,
        ).toJson()));
        await secureStorage.write(key: _rememberMeKey, value: 'true');
      }
    }

    return (user: user.toEntity(), failure: null);
  }

  @override
  Future<({bool success, Failure? failure})> logout() async {
    try {
      apiClient.clearAuthToken();
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _userKey);
      await secureStorage.delete(key: _rememberMeKey);
      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: CacheFailure(e.toString()));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}
