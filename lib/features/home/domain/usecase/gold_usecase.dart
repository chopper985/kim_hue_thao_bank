// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/data/repositories/gold_repository.dart';

@lazySingleton
class GoldUsecase {
  final GoldRepository _goldRepository;

  GoldUsecase(this._goldRepository);

  Future<Result<List<PriceBoardModel>>> getPriceBoard({required String date}) {
    return _goldRepository.getPriceBoard(date: date);
  }

  Future<Result<List<GoldTypeModel>>> getGoldTypes() {
    return _goldRepository.getGoldTypes();
  }
}
