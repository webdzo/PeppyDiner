class OccasionsModel {
  OccasionsModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
  });
  late final int id;
  late final String name;
  late final String parentId;
  late final String createdAt;
  late final String updatedAt;
  late final String reservedTableId;

  OccasionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['parent_id'] = parentId;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    return datas;
  }
}
