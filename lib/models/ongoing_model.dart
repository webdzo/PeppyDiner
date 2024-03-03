class OngoingOrdermodel {
  OngoingOrdermodel({
    required this.itemId,
    required this.itemName,
    required this.totalQuantity,
  });
  late final int itemId;
  late final String itemName;
  late final String totalQuantity;

  OngoingOrdermodel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    totalQuantity = json['total_quantity'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['item_id'] = itemId;
    datas['item_name'] = itemName;
    datas['total_quantity'] = totalQuantity;
    return datas;
  }
}
