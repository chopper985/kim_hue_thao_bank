// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/home/data/repositories/gold_repository.dart';

@lazySingleton
class DeleteGoldTypeUsecase {
  final GoldRepository _goldRepository;

  DeleteGoldTypeUsecase(this._goldRepository);

  Future<Result<bool>> call({required String id}) {
    return _goldRepository.deleteGoldType(id: id);
  }
}
