class CreateGoldTypeRequestModel {
  final String name;
  final int sortOrder;

  const CreateGoldTypeRequestModel({
    required this.name,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'sortOrder': sortOrder};
  }
}
