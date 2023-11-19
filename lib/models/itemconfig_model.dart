class ItemConfigModel {
  ItemConfigModel({
    required this.id,
    required this.name,
    required this.price,
    required this.expectedTime,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
    required this.itemCategoryId,
    required this.type,
    required this.description,
    required this.imgUrl,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.categoryName,
  });
  late final int id;
  late final String name;
  late final String price;
  late final String expectedTime;
  late final int enabled;
  late final String createdAt;
  late final String updatedAt;
  late final int itemCategoryId;
  late final String type;
  late final String description;
  late final String imgUrl;
  late final int subcategoryId;
  late final String subcategoryName;
  late final String categoryName;

  ItemConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    expectedTime = json['expectedTime'] ?? "";
    enabled = json['enabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemCategoryId = json['item_category_id'];
    type = json['type'] ?? "";
    description = json['description'] ?? "";
    imgUrl = json['imgUrl'] ?? "";
    subcategoryId = json['subcategory_id'];
    subcategoryName = json['subcategory_name'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['price'] = price;
    datas['expected_time'] = expectedTime;
    datas['enabled'] = enabled;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['item_category_id'] = itemCategoryId;
    datas['type'] = type;
    datas['description'] = description;
    datas['img_url'] = imgUrl;
    datas['subcategory_id'] = subcategoryId;
    datas['subcategory_name'] = subcategoryName;
    datas['category_name'] = categoryName;
    return datas;
  }
}
