// Package imports:
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
      query: 'date=$date',
    );

    if (!StatusCode.success.contains(response.statusCode)) {
      return Result.failure(ServerFailure());
    }

    final List rawList = response.data;

    return Result.success(
      rawList.map((item) => PriceBoardModel.fromJson(item)).toList(),
    );
  }

  Future<Result<List<GoldTypeModel>>> getGoldTypes() async {
    final response = await _baseRepository.getRoute(ApiEndpoints.goldTypes);

    if (!StatusCode.success.contains(response.statusCode)) {
      return Result.failure(ServerFailure());
    }
    final List rawList = response.data;
    final List<GoldTypeModel> goldTypes = rawList
        .map((item) => GoldTypeModel.fromJson(item))
        .toList();
    goldTypes.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return Result.success(goldTypes);
  }

  Future<Result<GoldTypeModel>> createGoldType({
    required CreateGoldTypeRequestModel request,
  }) async {
    final response = await _baseRepository.postRoute(
      ApiEndpoints.goldTypes,
      request.toJson(),
    );

    if (!StatusCode.success.contains(response.statusCode)) {
      return Result.failure(ServerFailure());
    }

    return Result.success(
      GoldTypeModel(
        id: response.data['id']?.toString() ?? '',
        name: request.name,
        sortOrder: request.sortOrder,
      ),
    );
  }

  Future<Result<bool>> updateGoldTypes({
    required List<GoldTypeModel> goldTypes,
  }) async {
    final response = await _baseRepository.putRoute(
      ApiEndpoints.goldTypes,
      goldTypes.map((item) => item.toJson()).toList(),
    );

    if (!StatusCode.success.contains(response.statusCode)) {
      return Result.failure(ServerFailure());
    }

    return Result.success(true);
  }

  Future<Result<bool>> updateGoldPrices({
    required UpdateGoldPricesRequestModel request,
  }) async {
    final response = await _baseRepository.putRoute(
      ApiEndpoints.goldPricesBatch,
      request.toJson(),
    );

    if (!StatusCode.success.contains(response.statusCode)) {
      return Result.failure(ServerFailure());
    }

    return Result.success(true);
  }
}
