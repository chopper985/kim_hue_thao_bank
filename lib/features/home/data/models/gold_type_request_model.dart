class GoldTypeRequestModel {
  final String goldTypeId;
  final int buyPrice;
  final int sellPrice;

  const GoldTypeRequestModel({
    required this.goldTypeId,
    required this.buyPrice,
    required this.sellPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'goldTypeId': goldTypeId,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
    };
  }
}
