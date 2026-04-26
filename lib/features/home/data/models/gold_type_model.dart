class GoldTypeModel {
  final String id;
  final String name;
  final int sortOrder;

  const GoldTypeModel({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  factory GoldTypeModel.fromJson(Map<String, dynamic> json) {
    return GoldTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sortOrder: json['sortOrder'] is int
          ? json['sortOrder'] as int
          : int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,
    );
  }

  GoldTypeModel copyWith({String? id, String? name, int? sortOrder}) {
    return GoldTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'sortOrder': sortOrder};
  }

  Map<String, dynamic> toCreateJson() {
    return {'name': name, 'sortOrder': sortOrder};
  }
}
