class EditItemconfigRequest {
  EditItemconfigRequest({
    this.itemname,
    this.description,
    this.category,
    this.subcategory,
    this.price,
    this.type,
    this.enabled,
    this.expectedTime,
  });
  String? itemname;
  String? description;
  String? category;
  String? subcategory;
  int? price;
  String? type;
  int? enabled;
  String? expectedTime;

  EditItemconfigRequest.fromJson(Map<String, dynamic> json) {
    itemname = json['itemname'];
    description = json['description'] ?? "";
    category = json['category'];
    subcategory = json['subcategory'];
    price = json['price'];
    type = json['type'];
    enabled = json['enabled'];
    expectedTime = json['expectedTime'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['itemname'] = itemname;
    datas['description'] = description;
    datas['category'] = category;
    datas['subcategory'] = subcategory;
    datas['price'] = price;
    datas['type'] = type;
    datas['enabled'] = enabled;
    datas['expected_time'] = expectedTime;
    return datas;
  }
}
