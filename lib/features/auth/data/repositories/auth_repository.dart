// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/constants/api_endpoints.dart';
import 'package:kht_gold/core/constants/http_status_code.dart';
import 'package:kht_gold/core/error/failure.dart';
import 'package:kht_gold/core/utils/datasources/base_repository.dart';
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/auth/data/datasources/auth_local_data.dart';
import 'package:kht_gold/features/auth/data/models/index.dart';

@lazySingleton
class AuthRepository {
  final BaseRepository _baseRepository;
  final AuthLocalData _authLocalData;

  AuthRepository(this._baseRepository, this._authLocalData);

  Future<Result<LoginResponseModel>> login({
    required String username,
    required String password,
  }) async {
    final response = await _baseRepository.postRoute(
      ApiEndpoints.login,
      {'username': username, 'password': password},
      options: Options(
        responseType: ResponseType.plain,
        validateStatus: (status) => true,
        headers: _baseRepository.getHeaders,
      ),
    );

    if (response.statusCode != StatusCode.ok &&
        response.statusCode != StatusCode.created) {
      return Result.failure(ServerFailure());
    }

    final loginResponse = LoginResponseModel.fromJson(
      _decodeMapResponse(response.data),
    );

    _authLocalData.saveAuth(
      accessToken: loginResponse.accessToken,
      expiresAt: loginResponse.expiresAt,
    );

    return Result.success(loginResponse);
  }

  bool get hasValidSession => _authLocalData.hasValidSession;

  void logout() {
    _authLocalData.clearAuth();
  }

  Map<String, dynamic> _decodeMapResponse(data) {
    if (data is String) {
      return Map<String, dynamic>.from(jsonDecode(data) as Map);
    }

    return Map<String, dynamic>.from(data as Map);
  }
}
