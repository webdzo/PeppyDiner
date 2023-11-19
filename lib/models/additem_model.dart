class AddItemsRequest {
  AddItemsRequest({
    required this.data,
    required this.reservationId,
    required this.notes,
  });
  late final List<Data> data;
  late final int reservationId;
  late final String notes;

  AddItemsRequest.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    reservationId = json['reservation_id'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['data'] = data.map((e) => e.toJson()).toList();
    datas['reservation_id'] = reservationId;
    datas['notes'] = notes;
    return datas;
  }
}

class Data {
  Data({
    required this.key,
    required this.itemId,
    required this.quantity,
    required this.name,
    required this.subCategory,
    required this.price,
  });
  late final String key;
  late final int itemId;
  late final int quantity;
  late final String name;
  late final String subCategory;
  late final String price;

  Data.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    name = json['name'];
    subCategory = json['subCategory'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['item_id'] = itemId;
    data['quantity'] = quantity;
    data['name'] = name;
    data['subCategory'] = subCategory;
    data['price'] = price;
    return data;
  }
}
