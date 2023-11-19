class PackagesModel {
  PackagesModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.benefits,
    required this.cost,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
  });
  late final int id;
  late final String name;
  late final String parentId;
  late final String benefits;
  late final String cost;
  late final String createdAt;
  late final String updatedAt;
  late final String reservedTableId;

  PackagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json["parent_id"] ?? "";
    benefits = json['benefits'];
    cost = json['cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json["reservedTableId"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['parent_id'] = parentId;
    datas['benefits'] = benefits;
    datas['cost'] = cost;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    return datas;
  }
}
