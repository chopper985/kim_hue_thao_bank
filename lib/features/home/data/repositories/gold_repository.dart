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
import 'package:kht_gold/features/home/data/models/index.dart';

@lazySingleton
class GoldRepository {
  final BaseRepository _baseRepository;

  GoldRepository(this._baseRepository);

  Future<Result<List<PriceBoardModel>>> getPriceBoard({
    required String date,
  }) async {
    final response = await _baseRepository.getRoute(
      ApiEndpoints.priceBoard,
      options: Options(responseType: ResponseType.plain),
      query: 'date=$date',
    );

    if (response.statusCode != StatusCode.ok) {
      return Result.failure(ServerFailure());
    }
    print("response ${response.runtimeType}");
    final List<dynamic> data = _decodeListResponse(response.data);
    final priceBoard =
        data.map((item) => PriceBoardModel.fromJson(_asJsonMap(item))).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Result.success(priceBoard);
  }

  Future<Result<List<GoldTypeModel>>> getGoldTypes() async {
    final response = await _baseRepository.getRoute(
      ApiEndpoints.goldTypes,
      options: Options(responseType: ResponseType.plain),
    );

    if (response.statusCode != StatusCode.ok) {
      return Result.failure(ServerFailure());
    }

    final List<dynamic> data = _decodeListResponse(response.data);
    final goldTypes =
        data.map((item) => GoldTypeModel.fromJson(_asJsonMap(item))).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Result.success(goldTypes);
  }

  List<dynamic> _decodeListResponse(data) {
    if (data is List<int>) {
      return jsonDecode(utf8.decode(data)) as List<dynamic>;
    }

    if (data is String) {
      return jsonDecode(data) as List<dynamic>;
    }

    if (data is List<dynamic>) {
      return data;
    }

    return [];
  }

  Map<String, dynamic> _asJsonMap(data) {
    return Map<String, dynamic>.from(data as Map);
  }
}
