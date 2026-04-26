// Package imports:
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/features/home/data/models/index.dart';
import 'package:kht_gold/features/home/domain/usecase/index.dart';

part 'management_state.dart';

@lazySingleton
class ManagementCubit extends Cubit<ManagementState> {
  ManagementCubit(
    this._getGoldTypesUsecase,
    this._getPriceBoardUsecase,
    this._createGoldTypeUsecase,
    this._updateGoldTypesUsecase,
    this._updateGoldPricesUsecase,
  ) : super(ManagementState.initial());

  final GetGoldTypesUsecase _getGoldTypesUsecase;
  final GetPriceBoardUsecase _getPriceBoardUsecase;
  final CreateGoldTypeUsecase _createGoldTypeUsecase;
  final UpdateGoldTypesUsecase _updateGoldTypesUsecase;
  final UpdateGoldPricesUsecase _updateGoldPricesUsecase;

  final DateFormat _requestDateFormat = DateFormat('yyyy-MM-dd');

  void setView(ManagementView view) {
    emit(state.copyWith(view: view, clearMessage: true));
  }

  Future<void> loadManagementData({
    DateTime? effectiveDate,
    bool preservePendingPrices = false,
  }) async {
    final DateTime nextDate = effectiveDate ?? state.effectiveDate;

    emit(
      state.copyWith(
        status: ManagementStatus.loading,
        effectiveDate: nextDate,
        hasPendingPriceChanges:
            preservePendingPrices && state.hasPendingPriceChanges,
        clearMessage: true,
      ),
    );

    final goldTypesResult = await _getGoldTypesUsecase();
    if (goldTypesResult.isFailure) {
      emit(
        state.copyWith(
          status: ManagementStatus.failure,
          message: Strings.managementLoadFailed.i18n,
        ),
      );
      return;
    }

    final List<GoldTypeModel> goldTypes = _sortGoldTypes(
      goldTypesResult.value ?? const [],
    );
    final priceBoardResult = await _getPriceBoardUsecase(
      date: _requestDateFormat.format(nextDate),
    );

    final List<PriceBoardModel> priceBoard = priceBoardResult.value ?? const [];

    emit(
      state.copyWith(
        status: ManagementStatus.loaded,
        effectiveDate: nextDate,
        goldTypes: goldTypes,
        priceItems: _buildPriceItems(goldTypes, priceBoard),
        hasPendingPriceChanges:
            preservePendingPrices && state.hasPendingPriceChanges,
        message: priceBoardResult.isFailure
            ? Strings.loadGoldPriceFailed.i18n
            : null,
      ),
    );
  }

  Future<void> changeEffectiveDate(DateTime date) async {
    await loadManagementData(effectiveDate: date);
  }

  void updatePriceField(String goldTypeId, bool isBuyPrice, String value) {
    final int index = state.priceItems.indexWhere(
      (item) => item.goldTypeId == goldTypeId,
    );
    if (index < 0) return;

    final ManagementPriceItem current = state.priceItems[index];
    final ManagementPriceItem updated = current.copyWith(
      buyPrice: isBuyPrice ? value : current.buyPrice,
      sellPrice: isBuyPrice ? current.sellPrice : value,
    );

    final List<ManagementPriceItem> priceItems = [...state.priceItems];
    priceItems[index] = updated;

    emit(
      state.copyWith(
        status: ManagementStatus.loaded,
        priceItems: priceItems,
        hasPendingPriceChanges: true,
        clearMessage: true,
      ),
    );
  }

  Future<void> savePriceBoard() async {
    emit(
      state.copyWith(
        status: ManagementStatus.savingPriceBoard,
        clearMessage: true,
      ),
    );

    final result = await _updateGoldPricesUsecase(
      request: UpdateGoldPricesRequestModel(
        items: state.priceItems
            .map(
              (item) => GoldTypeRequestModel(
                goldTypeId: item.goldTypeId,
                buyPrice: _priceToInt(item.buyPrice),
                sellPrice: _priceToInt(item.sellPrice),
              ),
            )
            .toList(),
        effectiveDate: _requestDateFormat.format(state.effectiveDate),
      ),
    );

    if (result.isFailure || result.value != true) {
      emit(
        state.copyWith(
          status: ManagementStatus.failure,
          message: Strings.saveFailed.i18n,
        ),
      );
      return;
    }

    await _reloadAfterSuccessfulMutation(
      status: ManagementStatus.priceBoardSaved,
      message: Strings.changesSaved.i18n,
      hasPendingPriceChanges: false,
    );
  }

  Future<void> saveGoldType({
    GoldTypeModel? goldType,
    required String name,
    required int sortOrder,
  }) async {
    emit(
      state.copyWith(
        status: ManagementStatus.savingGoldType,
        clearMessage: true,
      ),
    );

    if (goldType == null) {
      await _createGoldType(name: name, sortOrder: sortOrder);
      return;
    }

    final GoldTypeModel updatedGoldType = goldType.copyWith(
      name: name,
      sortOrder: sortOrder,
    );

    final result = await _updateGoldTypesUsecase(goldTypes: [updatedGoldType]);
    if (result.isFailure || result.value != true) {
      emit(
        state.copyWith(
          status: ManagementStatus.failure,
          message: Strings.saveFailed.i18n,
        ),
      );
      return;
    }

    await _reloadAfterSuccessfulMutation(
      status: ManagementStatus.goldTypeSaved,
      message: Strings.goldTypeSaved.i18n,
      hasPendingPriceChanges: state.hasPendingPriceChanges,
    );
  }

  void showDeleteUnavailable() {
    emit(
      state.copyWith(
        status: ManagementStatus.info,
        message: Strings.deleteGoldTypeUnavailable.i18n,
      ),
    );
  }

  Future<void> _createGoldType({
    required String name,
    required int sortOrder,
  }) async {
    final createResult = await _createGoldTypeUsecase(
      request: CreateGoldTypeRequestModel(name: name, sortOrder: sortOrder),
    );

    if (createResult.isFailure || createResult.value == null) {
      emit(
        state.copyWith(
          status: ManagementStatus.failure,
          message: Strings.saveFailed.i18n,
        ),
      );
      return;
    }

    final GoldTypeModel newGoldType = createResult.value!;

    final batchResult = await _updateGoldPricesUsecase(
      request: UpdateGoldPricesRequestModel(
        items: [
          GoldTypeRequestModel(
            goldTypeId: newGoldType.id,
            buyPrice: 0,
            sellPrice: 0,
          ),
        ],
        effectiveDate: _requestDateFormat.format(state.effectiveDate),
      ),
    );

    if (batchResult.isFailure || batchResult.value != true) {
      emit(
        state.copyWith(
          status: ManagementStatus.failure,
          message: Strings.saveFailed.i18n,
        ),
      );
      return;
    }

    await _reloadAfterSuccessfulMutation(
      status: ManagementStatus.goldTypeSaved,
      message: Strings.goldTypeSaved.i18n,
      hasPendingPriceChanges: false,
    );
  }

  Future<void> _reloadAfterSuccessfulMutation({
    required ManagementStatus status,
    required String message,
    required bool hasPendingPriceChanges,
  }) async {
    final goldTypesResult = await _getGoldTypesUsecase();
    if (goldTypesResult.isFailure) {
      emit(
        state.copyWith(
          status: ManagementStatus.failure,
          message: Strings.managementLoadFailed.i18n,
        ),
      );
      return;
    }

    final List<GoldTypeModel> goldTypes = _sortGoldTypes(
      goldTypesResult.value ?? const [],
    );
    final priceBoardResult = await _getPriceBoardUsecase(
      date: _requestDateFormat.format(state.effectiveDate),
    );

    emit(
      state.copyWith(
        status: status,
        goldTypes: goldTypes,
        priceItems: _buildPriceItems(
          goldTypes,
          priceBoardResult.value ?? const [],
        ),
        hasPendingPriceChanges: hasPendingPriceChanges,
        message: message,
      ),
    );
  }

  List<GoldTypeModel> _sortGoldTypes(List<GoldTypeModel> items) {
    final List<GoldTypeModel> sorted = [...items];
    sorted.sort((a, b) {
      final int sortOrder = a.sortOrder.compareTo(b.sortOrder);
      if (sortOrder != 0) return sortOrder;
      return a.name.compareTo(b.name);
    });
    return sorted;
  }

  List<ManagementPriceItem> _buildPriceItems(
    List<GoldTypeModel> goldTypes,
    List<PriceBoardModel> priceBoard,
  ) {
    return goldTypes.map((goldType) {
      final PriceBoardModel? matched = priceBoard.firstWhereOrNull(
        (item) => item.goldTypeId == goldType.id,
      );

      return ManagementPriceItem(
        goldTypeId: goldType.id,
        goldTypeName: goldType.name,
        sortOrder: goldType.sortOrder,
        buyPrice: _normalizePriceText(matched?.buyPriceDisplay ?? '0'),
        sellPrice: _normalizePriceText(matched?.sellPriceDisplay ?? '0'),
      );
    }).toList();
  }

  String _normalizePriceText(String value) {
    final String digits = value.replaceAll(RegExp('[^0-9]'), '');
    if (digits.isEmpty) return '0';
    return NumberFormat.decimalPattern('vi_VN').format(int.parse(digits));
  }

  int _priceToInt(String value) {
    final String digits = value.replaceAll(RegExp('[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }
}
