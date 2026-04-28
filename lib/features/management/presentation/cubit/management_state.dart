part of 'management_cubit.dart';

enum ManagementView { menu, dailyPrice, goldTypes }

enum ManagementStatus {
  initial,
  loading,
  loaded,
  savingPriceBoard,
  savingGoldType,
  priceBoardSaved,
  goldTypeSaved,
  goldTypeDeleted,
  failure,
  info,
}

class ManagementState extends Equatable {
  const ManagementState({
    required this.status,
    required this.view,
    required this.effectiveDate,
    required this.goldTypes,
    required this.priceItems,
    required this.hasPendingPriceChanges,
    this.message,
  });

  factory ManagementState.initial() {
    return ManagementState(
      status: ManagementStatus.initial,
      view: ManagementView.menu,
      effectiveDate: DateTime.now(),
      goldTypes: const [],
      priceItems: const [],
      hasPendingPriceChanges: false,
    );
  }

  final ManagementStatus status;
  final ManagementView view;
  final DateTime effectiveDate;
  final List<GoldTypeModel> goldTypes;
  final List<ManagementPriceItem> priceItems;
  final bool hasPendingPriceChanges;
  final String? message;

  bool get isLoading =>
      status == ManagementStatus.loading || status == ManagementStatus.initial;

  bool get isSavingPriceBoard => status == ManagementStatus.savingPriceBoard;
  bool get isSavingGoldType => status == ManagementStatus.savingGoldType;

  ManagementState copyWith({
    ManagementStatus? status,
    ManagementView? view,
    DateTime? effectiveDate,
    List<GoldTypeModel>? goldTypes,
    List<ManagementPriceItem>? priceItems,
    bool? hasPendingPriceChanges,
    String? message,
    bool clearMessage = false,
  }) {
    return ManagementState(
      status: status ?? this.status,
      view: view ?? this.view,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      goldTypes: goldTypes ?? this.goldTypes,
      priceItems: priceItems ?? this.priceItems,
      hasPendingPriceChanges:
          hasPendingPriceChanges ?? this.hasPendingPriceChanges,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    view,
    effectiveDate,
    goldTypes,
    priceItems,
    hasPendingPriceChanges,
    message,
  ];
}

class ManagementPriceItem extends Equatable {
  const ManagementPriceItem({
    required this.goldTypeId,
    required this.goldTypeName,
    required this.sortOrder,
    required this.buyPrice,
    required this.sellPrice,
  });

  final String goldTypeId;
  final String goldTypeName;
  final int sortOrder;
  final String buyPrice;
  final String sellPrice;

  ManagementPriceItem copyWith({
    String? goldTypeName,
    int? sortOrder,
    String? buyPrice,
    String? sellPrice,
  }) {
    return ManagementPriceItem(
      goldTypeId: goldTypeId,
      goldTypeName: goldTypeName ?? this.goldTypeName,
      sortOrder: sortOrder ?? this.sortOrder,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
    );
  }

  @override
  List<Object> get props => [
    goldTypeId,
    goldTypeName,
    sortOrder,
    buyPrice,
    sellPrice,
  ];
}
