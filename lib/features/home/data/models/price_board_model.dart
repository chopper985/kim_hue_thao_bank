class PriceBoardModel {
  final String goldTypeId;
  final String goldTypeName;
  final int sortOrder;
  final String buyPriceDisplay;
  final String sellPriceDisplay;
  final DateTime? updatedAt;

  const PriceBoardModel({
    required this.goldTypeId,
    required this.goldTypeName,
    required this.sortOrder,
    required this.buyPriceDisplay,
    required this.sellPriceDisplay,
    required this.updatedAt,
  });

  factory PriceBoardModel.fromJson(Map<String, dynamic> json) {
    return PriceBoardModel(
      goldTypeId: json['goldTypeId']?.toString() ?? '',
      goldTypeName: json['goldTypeName']?.toString() ?? '',
      sortOrder: json['sortOrder'] is int
          ? json['sortOrder'] as int
          : int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,
      buyPriceDisplay: json['buyPriceDisplay']?.toString() ?? '',
      sellPriceDisplay: json['sellPriceDisplay']?.toString() ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}
