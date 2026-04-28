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
    this._getGoldTypes,
    this._getPriceBoard,
    this._createGoldType,
    this._deleteGoldType,
    this._updateGoldTypes,
    this._updateGoldPrices,
  ) : super(ManagementState.initial());

  final GetGoldTypesUsecase _getGoldTypes;
  final GetPriceBoardUsecase _getPriceBoard;
  final CreateGoldTypeUsecase _createGoldType;
  final DeleteGoldTypeUsecase _deleteGoldType;
  final UpdateGoldTypesUsecase _updateGoldTypes;
  final UpdateGoldPricesUsecase _updateGoldPrices;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  // ─── Navigation ───────────────────────────────────────────────────────────

  void setView(ManagementView view) {
    emit(state.copyWith(view: view, clearMessage: true));
  }

  // ─── Data loading ─────────────────────────────────────────────────────────

  Future<void> loadManagementData({
    DateTime? effectiveDate,
    bool preservePendingPrices = false,
  }) async {
    final date = effectiveDate ?? state.effectiveDate;

    emit(
      state.copyWith(
        status: ManagementStatus.loading,
        effectiveDate: date,
        hasPendingPriceChanges:
            preservePendingPrices && state.hasPendingPriceChanges,
        clearMessage: true,
      ),
    );

    final goldTypesResult = await _getGoldTypes();
    if (goldTypesResult.isFailure) {
      return _emitFailure(
        goldTypesResult.error?.message ?? Strings.serverFailure.i18n,
      );
    }

    final goldTypes = _sorted(goldTypesResult.value ?? []);
    final priceBoardResult = await _getPriceBoard(
      date: _dateFormat.format(date),
    );

    emit(
      state.copyWith(
        status: ManagementStatus.loaded,
        effectiveDate: date,
        goldTypes: goldTypes,
        priceItems: _buildPriceItems(goldTypes, priceBoardResult.value ?? []),
        hasPendingPriceChanges:
            preservePendingPrices && state.hasPendingPriceChanges,
        message: priceBoardResult.isFailure
            ? Strings.loadGoldPriceFailed.i18n
            : null,
      ),
    );
  }

  Future<void> changeEffectiveDate(DateTime date) =>
      loadManagementData(effectiveDate: date);

  // ─── Price editing ────────────────────────────────────────────────────────

  void updatePriceField(String goldTypeId, bool isBuyPrice, String value) {
    final index = state.priceItems.indexWhere(
      (e) => e.goldTypeId == goldTypeId,
    );
    if (index < 0) return;

    final current = state.priceItems[index];
    final newBuy = isBuyPrice ? value : current.buyPrice;
    final newSell = isBuyPrice ? current.sellPrice : value;

    if (newBuy == current.buyPrice && newSell == current.sellPrice) return;

    final updated = List.of(state.priceItems)
      ..[index] = current.copyWith(buyPrice: newBuy, sellPrice: newSell);

    emit(
      state.copyWith(
        status: ManagementStatus.loaded,
        priceItems: updated,
        hasPendingPriceChanges: true,
        clearMessage: true,
      ),
    );
  }

  // ─── Save price board ─────────────────────────────────────────────────────

  Future<void> savePriceBoard() async {
    emit(
      state.copyWith(
        status: ManagementStatus.savingPriceBoard,
        clearMessage: true,
      ),
    );

    final result = await _updateGoldPrices(
      request: UpdateGoldPricesRequestModel(
        effectiveDate: _dateFormat.format(state.effectiveDate),
        items: state.priceItems
            .map(
              (e) => GoldTypeRequestModel(
                goldTypeId: e.goldTypeId,
                buyPrice: _toInt(e.buyPrice),
                sellPrice: _toInt(e.sellPrice),
              ),
            )
            .toList(),
      ),
    );

    if (result.isFailure || result.value != true) {
      return _emitFailure(Strings.saveFailed.i18n);
    }

    await _reloadAfterMutation(
      status: ManagementStatus.priceBoardSaved,
      message: Strings.changesSaved.i18n,
      hasPendingPriceChanges: false,
    );
  }

  // ─── Gold type CRUD ───────────────────────────────────────────────────────

  Future<void> saveGoldType({
    GoldTypeModel? existing,
    required String name,
    required int sortOrder,
  }) async {
    emit(
      state.copyWith(
        status: ManagementStatus.savingGoldType,
        clearMessage: true,
      ),
    );

    if (existing == null) {
      await _createNewGoldType(name: name, sortOrder: sortOrder);
    } else {
      await _updateExistingGoldType(existing, name: name, sortOrder: sortOrder);
    }
  }

  Future<void> deleteGoldType(GoldTypeModel goldType) async {
    emit(
      state.copyWith(
        status: ManagementStatus.savingGoldType,
        clearMessage: true,
      ),
    );

    final result = await _deleteGoldType(id: goldType.id);
    if (result.isFailure || result.value != true) {
      return _emitFailure(result.error?.message ?? Strings.serverFailure.i18n);
    }

    await _reloadAfterMutation(
      status: ManagementStatus.goldTypeDeleted,
      message: Strings.goldTypeDeleted.i18n,
      hasPendingPriceChanges: false,
    );
  }

  // ─── Private: gold type mutations ─────────────────────────────────────────

  Future<void> _createNewGoldType({
    required String name,
    required int sortOrder,
  }) async {
    final createResult = await _createGoldType(
      request: CreateGoldTypeRequestModel(name: name, sortOrder: sortOrder),
    );

    if (createResult.isFailure || createResult.value == null) {
      return _emitFailure(
        createResult.error?.message ?? Strings.serverFailure.i18n,
      );
    }

    final priceResult = await _updateGoldPrices(
      request: UpdateGoldPricesRequestModel(
        effectiveDate: _dateFormat.format(state.effectiveDate),
        items: [
          GoldTypeRequestModel(
            goldTypeId: createResult.value!.id,
            buyPrice: 0,
            sellPrice: 0,
          ),
        ],
      ),
    );

    if (priceResult.isFailure || priceResult.value != true) {
      return _emitFailure(
        priceResult.error?.message ?? Strings.serverFailure.i18n,
      );
    }

    await _reloadAfterMutation(
      status: ManagementStatus.goldTypeSaved,
      message: Strings.goldTypeSaved.i18n,
      hasPendingPriceChanges: false,
    );
  }

  Future<void> _updateExistingGoldType(
    GoldTypeModel existing, {
    required String name,
    required int sortOrder,
  }) async {
    final result = await _updateGoldTypes(
      goldTypes: [existing.copyWith(name: name, sortOrder: sortOrder)],
    );

    if (result.isFailure || result.value != true) {
      return _emitFailure(Strings.saveFailed.i18n);
    }

    await _reloadAfterMutation(
      status: ManagementStatus.goldTypeSaved,
      message: Strings.goldTypeSaved.i18n,
      hasPendingPriceChanges: state.hasPendingPriceChanges,
    );
  }

  // ─── Private: shared helpers ──────────────────────────────────────────────

  Future<void> _reloadAfterMutation({
    required ManagementStatus status,
    required String message,
    required bool hasPendingPriceChanges,
  }) async {
    final goldTypesResult = await _getGoldTypes();
    if (goldTypesResult.isFailure) {
      return _emitFailure(
        goldTypesResult.error?.message ?? Strings.serverFailure.i18n,
      );
    }

    final goldTypes = _sorted(goldTypesResult.value ?? []);
    final priceBoardResult = await _getPriceBoard(
      date: _dateFormat.format(state.effectiveDate),
    );

    emit(
      state.copyWith(
        status: status,
        message: message,
        goldTypes: goldTypes,
        priceItems: _buildPriceItems(goldTypes, priceBoardResult.value ?? []),
        hasPendingPriceChanges: hasPendingPriceChanges,
      ),
    );
  }

  void _emitFailure(String message) {
    emit(state.copyWith(status: ManagementStatus.failure, message: message));
  }

  List<GoldTypeModel> _sorted(List<GoldTypeModel> items) =>
      [...items]..sort((a, b) {
        final cmp = a.sortOrder.compareTo(b.sortOrder);
        return cmp != 0 ? cmp : a.name.compareTo(b.name);
      });

  List<ManagementPriceItem> _buildPriceItems(
    List<GoldTypeModel> goldTypes,
    List<PriceBoardModel> priceBoard,
  ) {
    return goldTypes.map((type) {
      final matched = priceBoard.firstWhereOrNull(
        (p) => p.goldTypeId == type.id,
      );
      return ManagementPriceItem(
        goldTypeId: type.id,
        goldTypeName: type.name,
        sortOrder: type.sortOrder,
        buyPrice: _formatPrice(matched?.buyPriceDisplay ?? '0'),
        sellPrice: _formatPrice(matched?.sellPriceDisplay ?? '0'),
      );
    }).toList();
  }

  String _formatPrice(String value) {
    final digits = value.replaceAll(RegExp('[^0-9]'), '');
    if (digits.isEmpty) return '0';
    return NumberFormat.decimalPattern('vi_VN').format(int.parse(digits));
  }

  int _toInt(String value) =>
      int.tryParse(value.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
}
