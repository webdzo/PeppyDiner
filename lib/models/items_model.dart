class ItemsModel {
  ItemsModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.expectedTime,
      required this.enabled,
      this.createdAt,
      this.updatedAt,
      required this.itemCategoryId,
      required this.type});
  late final int id;
  late final String name;
  late final String price;
  late final String expectedTime;
  late final int enabled;
  late final String? createdAt;
  late final String? updatedAt;
  late final int itemCategoryId;
  late final String type;

  ItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    expectedTime = json['expected_time'] ?? "";
    enabled = json['enabled'];
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    itemCategoryId = json['itemCategoryId'];
    type = json["type"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['expected_time'] = expectedTime;
    data['enabled'] = enabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['itemCategoryId'] = itemCategoryId;
    data["type"] = type;
    return data;
  }
}
