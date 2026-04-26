// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/data/repositories/gold_repository.dart';

@lazySingleton
class CreateGoldTypeUsecase {
  final GoldRepository _goldRepository;

  CreateGoldTypeUsecase(this._goldRepository);

  Future<Result<GoldTypeModel>> call({
    required CreateGoldTypeRequestModel request,
  }) {
    return _goldRepository.createGoldType(request: request);
  }
}
