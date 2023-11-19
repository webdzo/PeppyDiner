class AddExpenseRequest {
  AddExpenseRequest({
    this.data,
  });
  Data? data;

  AddExpenseRequest.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['data'] = data?.toJson();
    return datas;
  }
}

class Data {
  Data({
    this.category,
    this.identifier,
    this.price,
    this.comments,
    this.type,
    this.categoryId,
  });
  String? category;
  String? identifier;
  String? price;
  String? comments;
  String? type;
  int? categoryId;

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    identifier = json['identifier'];
    price = json['price'];
    comments = json['comments'];
    type = json['type'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category;
    data['identifier'] = identifier;
    data['price'] = price;
    data['comments'] = comments;
    data['type'] = type;
    data['category_id'] = categoryId;
    return data;
  }
}
