// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/data/repositories/gold_repository.dart';

@lazySingleton
class UpdateGoldPricesUsecase {
  final GoldRepository _goldRepository;

  UpdateGoldPricesUsecase(this._goldRepository);

  Future<Result<bool>> call({required UpdateGoldPricesRequestModel request}) {
    return _goldRepository.updateGoldPrices(request: request);
  }
}
