class MainCategoryModel {
  MainCategoryModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.splitItems,
    required this.displayUser,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String parentId;
  late final bool splitItems;
  late final bool displayUser;
  late final String createdAt;
  late final String updatedAt;

  MainCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parentId'] ?? "";

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
