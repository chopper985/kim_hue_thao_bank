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
  final GetPriceBoardUsecase _getPriceBoardUsecase;
  DateTime? _lastRequestedDate;

  HomeCubit(this._getPriceBoardUsecase) : super(HomeInitial());

  Future<void> getPriceBoard({required DateTime date}) async {
    _lastRequestedDate = DateTime(date.year, date.month, date.day);
    emit(HomePriceBoardLoading());

    final result = await _getPriceBoardUsecase(
      date: DateFormat('yyyy-MM-dd').format(date),
    );

    if (result.isSuccess) {
      final priceBoardList = result.value ?? [];
      priceBoardList.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      emit(HomePriceBoardLoaded(priceBoardList));
      return;
    }

    emit(HomePriceBoardFailure());
  }

  Future<void> refreshIfViewingDate({required DateTime date}) async {
    if (_lastRequestedDate == null) return;

    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    if (_lastRequestedDate != normalizedDate) return;

    await getPriceBoard(date: normalizedDate);
  }
}
