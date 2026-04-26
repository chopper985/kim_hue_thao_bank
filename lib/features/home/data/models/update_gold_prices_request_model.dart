// Project imports:
import 'package:kht_gold/features/home/data/models/gold_type_request_model.dart';

class UpdateGoldPricesRequestModel {
  final List<GoldTypeRequestModel> items;
  final String effectiveDate;

  const UpdateGoldPricesRequestModel({
    required this.items,
    required this.effectiveDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'effectiveDate': effectiveDate,
    };
  }
}
