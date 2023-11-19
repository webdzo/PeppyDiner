class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.parentId,
    this.type,
    this.createdAt,
    this.updatedAt,
  });
  int? id;
  String? name;
  int? parentId;
  String? type;
  String? createdAt;
  String? updatedAt;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'] ?? "";

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
