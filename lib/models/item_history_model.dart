class ItemhistoryModel {
  ItemhistoryModel({
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.subcategoryName,
    required this.itemCompleted,
    required this.itemTotal,
    required this.orderNo,
    required this.diningType,
    required this.tableName,
    required this.rsName,
     this.guests,
  });
  late final String itemName;
  late final String itemPrice;
  late final int itemQuantity;
  late final String subcategoryName;
  late final int itemCompleted;
  late final String itemTotal;
  late final String orderNo;
  late final String diningType;
  late final String tableName;
  late final String rsName;
  late final Null guests;
  
  ItemhistoryModel.fromJson(Map<String, dynamic> json){
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemQuantity = json['item_quantity'];
    subcategoryName = json['subcategory_name'];
    itemCompleted = json['item_completed'];
    itemTotal = json['item_total'];
    orderNo = json['order_no'];
    diningType = json['dining_type'];
    tableName = json['table_name'];
    rsName = json['rs_name'];
    guests = null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    data['item_quantity'] = itemQuantity;
    data['subcategory_name'] = subcategoryName;
    data['item_completed'] = itemCompleted;
    data['item_total'] = itemTotal;
    data['order_no'] = orderNo;
    data['dining_type'] = diningType;
    data['table_name'] = tableName;
    data['rs_name'] = rsName;
    data['guests'] = guests;
    return data;
  }
}