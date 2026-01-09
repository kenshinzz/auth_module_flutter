import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Response wrapper for API calls
class ApiResponse<T> {
  final int? statusCode;
  final T? data;
  final String? errorMessage;

  ApiResponse({
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

/// Exception types for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseData;
  final ApiExceptionType type;

  ApiException({
    required this.message,
    this.statusCode,
    this.responseData,
    required this.type,
  });

  @override
  String toString() => 'ApiException: $message (type: $type, statusCode: $statusCode)';
}

enum ApiExceptionType {
  connectionTimeout,
  receiveTimeout,
  serverError,
  unauthorized,
  validationError,
  unknown,
}

class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final http.Client _client;
  final Map<String, String> _defaultHeaders;
  String? _authToken;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _defaultHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse('$baseUrl$path');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return uri;
  }

  Future<ApiResponse<Map<String, dynamic>>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: data != null ? jsonEncode(data) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No internet connection',
        type: ApiExceptionType.connectionTimeout,
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        message: e.message,
        type: ApiExceptionType.unknown,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        type: ApiExceptionType.unknown,
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No internet connection',
        type: ApiExceptionType.connectionTimeout,
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        message: e.message,
        type: ApiExceptionType.unknown,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        type: ApiExceptionType.unknown,
      );
    }
  }

  ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    Map<String, dynamic>? data;

    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        // Response body is not valid JSON
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        statusCode: response.statusCode,
        data: data,
      );
    }

    // Handle error responses
    final errorType = switch (response.statusCode) {
      401 => ApiExceptionType.unauthorized,
      422 => ApiExceptionType.validationError,
      >= 500 => ApiExceptionType.serverError,
      _ => ApiExceptionType.unknown,
    };

    throw ApiException(
      message: data?['message'] as String? ?? 'Request failed',
      statusCode: response.statusCode,
      responseData: data,
      type: errorType,
    );
  }

  void dispose() {
    _client.close();
  }
}
