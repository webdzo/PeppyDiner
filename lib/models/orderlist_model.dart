class OrderlistModel {
  OrderlistModel({
    required this.id,
    required this.orderNo,
    required this.tableId,
    required this.diningType,
    required this.deliveryPartner,
    required this.isDraft,
    required this.completed,
    required this.completedWhen,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
    required this.itemOrders,
  });
  late final int id;
  late final String orderNo;
  late final int tableId;
  late final String diningType;
  late final String deliveryPartner;
  late final bool isDraft;
  late final bool completed;
  late final String completedWhen;
  late final String createdAt;
  late final String updatedAt;
  late final int reservedTableId;
  late final List<ItemOrders> itemOrders;

  OrderlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    tableId = json['table_id'] ?? 0;
    diningType = json['dining_type'];
    deliveryPartner = json['delivery_partner'] ?? "";
    isDraft = json['is_draft'];
    completed = json['completed'];
    completedWhen = json["completed_when"] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'];
    itemOrders = List.from(json['item_orders'])
        .map((e) => ItemOrders.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['order_no'] = orderNo;
    datas['table_id'] = tableId;
    datas['dining_type'] = diningType;
    datas['delivery_partner'] = deliveryPartner;
    datas['is_draft'] = isDraft;
    datas['completed'] = completed;
    datas['completed_when'] = completedWhen;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    datas['item_orders'] = itemOrders.map((e) => e.toJson()).toList();
    return datas;
  }
}

class ItemOrders {
  ItemOrders({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.subcategoryName,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
  });
  late final int id;
  late final int itemId;
  late final String itemName;
  late final String itemPrice;
  int? itemQuantity;
  late final String subcategoryName;
  late final String createdAt;
  late final String updatedAt;
  late final int orderId;
  late final bool completed;
  late final bool rejected;

  ItemOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemQuantity = json['item_quantity'];
    subcategoryName = json['subcategory_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderId = json['orderId'];
    completed = json['completed'] ?? false;
    rejected = json['rejected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['item_id'] = itemId;
    datas['item_name'] = itemName;
    datas['item_price'] = itemPrice;
    datas['item_quantity'] = itemQuantity;
    datas['subcategory_name'] = subcategoryName;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['orderId'] = orderId;
    return datas;
  }
}
