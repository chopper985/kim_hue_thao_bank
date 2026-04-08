// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/domain/usecase/index.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GoldUsecase _goldUsecase;

  HomeCubit(this._goldUsecase) : super(HomeInitial());

  Future<void> getPriceBoard({required DateTime date}) async {
    emit(HomePriceBoardLoading());

    final result = await _goldUsecase.getPriceBoard(
      date: DateFormat('yyyy-MM-dd').format(date),
    );

    if (result.isSuccess) {
      emit(HomePriceBoardLoaded(result.value ?? []));
      return;
    }

    emit(HomePriceBoardFailure());
  }
}
