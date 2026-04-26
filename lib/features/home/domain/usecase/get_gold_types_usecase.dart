// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/data/repositories/gold_repository.dart';

@lazySingleton
class GetGoldTypesUsecase {
  final GoldRepository _goldRepository;

  GetGoldTypesUsecase(this._goldRepository);

  Future<Result<List<GoldTypeModel>>> call() {
    return _goldRepository.getGoldTypes();
  }
}
