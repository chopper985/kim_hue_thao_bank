// Dart imports:
import 'dart:async';
import 'dart:convert' as convert;

// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/constants/api_endpoints.dart';
import 'package:kht_gold/core/constants/http_status_code.dart';
import 'package:kht_gold/core/types/extensions/int_extension.dart';
import 'package:kht_gold/core/utils/dio_api/dio_configuration.dart';

@lazySingleton
class BaseRepository {
  // final UserLocal _userLocal;
  final DioConfiguration _dioConfiguration;
  BaseRepository(
    // this._userLocal,
    this._dioConfiguration,
  );

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: 10000.milliseconds,
      receiveTimeout: 10000.milliseconds,
      sendTimeout: 10000.milliseconds,
    ),
  ); // with default Options

  Future<Response<dynamic>> downloadFile(
    String url,
    String path,
    Function onReceive,
  ) async {
    return await dio.download(
      url,
      path,
      options: getOptions,
      onReceiveProgress: (received, total) {
        onReceive(received, total);
      },
    );
  }

  Future<Response<dynamic>> postFormData(
    String gateway,
    FormData formData,
  ) async {
    try {
      return await dio.post(gateway, data: formData, options: getOptions);
    } on DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> putFormData(
    String gateway,
    FormData formData,
  ) async {
    try {
      return await dio.put(gateway, data: formData, options: getOptions);
    } on DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> postRoute(
    String gateway,
    body, {
    String? query,
    Options? options,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] = element
              .split('=')[1]
              .toString();
        });
      }

      return await dio.post(
        gateway,
        data: convert.jsonEncode(body),
        options: options ?? getOptions,
        queryParameters: query == null ? null : paramsObject,
      );
    } on DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> putRoute(
    String gateway,
    Map<String, dynamic> body, {
    String? query,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] = element
              .split('=')[1]
              .toString();
        });
      }

      return await dio.put(
        gateway,
        data: convert.jsonEncode(body),
        options: getOptions,
        queryParameters: query == null ? null : paramsObject,
      );
    } on DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> patchRoute(
    String gateway, {
    String? query,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] = element
              .split('=')[1]
              .toString();
        });
      }

      return await dio.patch(
        gateway,
        data: body == null ? null : convert.jsonEncode(body),
        options: getOptions,
        queryParameters: query == null ? null : paramsObject,
      );
    } on DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> getRoute(
    String gateway, {
    String? params,
    String? query,
    Options? options,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] = element
              .split('=')[1]
              .toString();
        });
      }
      return await dio.get(
        gateway,
        data: body == null ? null : convert.jsonEncode(body),
        options: options ?? getOptions,
        queryParameters: query == null ? null : paramsObject,
      );
    } on DioException catch (exception) {
      print("exception $exception");
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> deleteRoute(
    String gateway, {
    String? params,
    String? query,
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] = element
              .split('=')[1]
              .toString();
        });
      }

      return await dio.delete(
        gateway,
        data: formData ?? (body == null ? null : convert.jsonEncode(body)),
        options: getOptions,
        queryParameters: query == null ? null : paramsObject,
      );
    } on DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Response catchDioError({
    required DioException exception,
    required String gateway,
  }) {
    return Response(
      requestOptions: RequestOptions(path: gateway),
      statusCode: StatusCode.badGateway,
      statusMessage: exception.response?.statusMessage,
    );
  }

  Options get getOptions {
    return Options(validateStatus: (status) => true, headers: getHeaders);
  }

  Map<String, String> getHeadersLogout(String deviceUuid) {
    return {
      // 'Authorization':
      //     'Bearer ${_userLocal.getAccessToken.isEmpty ? _userLocal.getBackupToken()[0] : _userLocal.getAccessToken}',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'X-Device-ID': deviceUuid,
    };
  }

  Map<String, String> get getHeaders {
    return {
      // 'Authorization':
      //     'Bearer ${_userLocal.getAccessToken.isEmpty ? _userLocal.getBackupToken()[0] : _userLocal.getAccessToken}',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
    };
  }

  Future<void> configureDio() async {
    await Future.wait([
      _dioConfiguration.configuration(dio).then((newClient) {
        dio = newClient;
        _dioConfiguration.onRefreshToken();
      }),
    ]);
  }
}
