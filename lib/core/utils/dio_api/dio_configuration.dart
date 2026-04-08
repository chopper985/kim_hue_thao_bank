// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart' as retry;
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/constants/api_endpoints.dart';
import 'package:kht_gold/core/constants/http_status_code.dart';
import 'package:kht_gold/core/types/extensions/int_extension.dart';
import 'package:kht_gold/core/utils/datasources/base_repository.dart';
import 'package:kht_gold/core/utils/dio_api/completer_queue.dart';

@lazySingleton
class DioConfiguration {
  // final UserLocal _userLocal;
  DioConfiguration();

  bool _isRefreshing = false;
  final CompleterQueue<(String, String)> _refreshTokenCompleters =
      CompleterQueue<(String, String)>();

  // MARK: public methods
  Future<Dio> configuration(Dio dioClient) async {
    // Integration retry
    dioClient.interceptors.add(
      retry.RetryInterceptor(
        dio: dioClient,
        // logPrint: print, // specify log function (optional)
        retryDelays: [
          // set delays between retries (optional)
          1.seconds, // wait 1 sec before first retry
          2.seconds, // wait 2 sec before second retry
          3.seconds, // wait 3 sec before third retry
        ],
      ),
    );

    // Add interceptor for prevent response when system is maintaining...
    dioClient.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.statusCode == StatusCode.unauthorized
          // && _userLocal.getRefreshToken.isNotEmpty
          ) {
            try {
              final String oldAccessToken =
                  (response.requestOptions.headers['Authorization'] ?? '')
                      .toString()
                      .split(' ')
                      .last;

              final (String accessToken, String _) = await onRefreshToken(
                oldAccessToken: oldAccessToken,
              );

              response.requestOptions.headers['Authorization'] =
                  'Bearer $accessToken';

              final Response cloneReq = await dioClient.fetch(
                response.requestOptions,
              );

              handler.resolve(cloneReq);
            } catch (_) {
              handler.next(response);
              _logOut();
            }
          } else {
            handler.next(response);
          }
        },
      ),
    );

    return dioClient;
  }

  Future<(String, String)> onRefreshToken({
    String oldAccessToken = '',
    Function(String accessToken, String refreshToken)? callback,
  }) async {
    // if (oldAccessToken != _userLocal.getAccessToken &&
    //     oldAccessToken.isNotEmpty) {
    //   return (_userLocal.getAccessToken, _userLocal.getRefreshToken);
    // }

    final completer = Completer<(String, String)>();
    _refreshTokenCompleters.add(completer);

    if (!_isRefreshing) {
      _isRefreshing = true;

      final (String, String) result = await _performRefreshToken(
        callback: callback,
      );

      _isRefreshing = false;
      _refreshTokenCompleters.completeAllQueue(result);
    }

    return completer.future;
  }

  // MARK: Private methods
  Future<(String, String)> _performRefreshToken({
    Function(String accessToken, String refreshToken)? callback,
  }) async {
    // if (_userLocal.getRefreshToken.isEmpty) {
    //   if (_userLocal.getAccessToken.isNotEmpty) {
    //     _logOut();
    //   }
    //   return ("", "");
    // }
    // String deviceUuid = DeviceHelper.deviceModel?.deviceUuid ?? "";

    // if (deviceUuid.isEmpty) {
    //   deviceUuid = (await DeviceHelper().getDeviceDetails()).deviceUuid;
    // }

    final Response response = await BaseRepository.dio.get(
      ApiEndpoints.refreshToken,
      // options: BaseRepository.getOptions,
    );

    debugPrint("executed /refreshToken * times");

    if (response.statusCode == StatusCode.ok) {
      final String accessToken = response.data['data']['accessToken'];
      final String refreshToken = response.data['data']['refreshToken'];

      // _userLocal.saveAccessToken(accessToken, refreshToken);

      callback?.call(accessToken, refreshToken);

      return (accessToken, refreshToken);
    }

    return ("", "");
  }

  void _logOut() {
    // _userLocal.clearAccessToken();
    // showDialogLoading();
    // AppBloc.instance.authBloc.add(AuthLogout());
  }
}
