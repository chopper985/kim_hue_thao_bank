// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/data/repositories/gold_repository.dart';

@lazySingleton
class UpdateGoldTypesUsecase {
  final GoldRepository _goldRepository;

  UpdateGoldTypesUsecase(this._goldRepository);

  Future<Result<bool>> call({required List<GoldTypeModel> goldTypes}) {
    return _goldRepository.updateGoldTypes(goldTypes: goldTypes);
  }
}
