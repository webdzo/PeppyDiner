abstract class Copyable<T> {
  T copy();
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.orderNo,
    required this.roomName,
    required this.roomId,
    required this.isDraft,
    required this.eta,
    required this.completed,
    required this.guestId,
    required this.maxMins,
    required this.createdAt,
    required this.updatedAt,
    required this.reservationId,
    required this.itemOrders,
    required this.guestName,
    required this.guestContact,
  });
  late final int id;
  late final String orderNo;
  late final String roomName;
  late final int roomId;
  late final bool isDraft;
  late final String eta;
  late final bool completed;
  late final String guestId;
  late final String maxMins;
  late final String createdAt;
  late final String updatedAt;
  late final int reservationId;
  late final List<ItemOrders> itemOrders;
  late final String guestName;
  late final String guestContact;

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    roomName = json['room_name'];
    roomId = json['room_id'];
    isDraft = json['is_draft'];
    eta = json['eta'];
    completed = json['completed'];
    guestId = json['guestId'] ?? "";
    maxMins = json['maxMins'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservationId = json['reservationId'];
    itemOrders = List.from(json['item_orders'])
        .map((e) => ItemOrders.fromJson(e))
        .toList();
    guestName = json['guest_name'];
    guestContact = json['guest_contact'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['room_name'] = roomName;
    data['room_id'] = roomId;
    data['is_draft'] = isDraft;
    data['eta'] = eta;
    data['completed'] = completed;
    data['guest_id'] = guestId;
    data['max_mins'] = maxMins;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reservationId'] = reservationId;
    data['item_orders'] = itemOrders.map((e) => e.toJson()).toList();
    data['guest_name'] = guestName;
    data['guest_contact'] = guestContact;
    return data;
  }
}

class ItemOrders extends Copyable<ItemOrders> {
  @override
  ItemOrders copy() => ItemOrders(
        id: id,
        itemId: itemId,
        itemName: itemName,
        itemPrice: itemPrice,
        itemQuantity: itemQuantity,
        itemExpectedTime: itemExpectedTime,
        roomId: roomId,
        subcategoryName: subcategoryName,
        bookedDate: bookedDate,
        isDraft: isDraft,
        createdAt: createdAt,
        updatedAt: updatedAt,
        orderId: orderId,
      );
  ItemOrders({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.itemExpectedTime,
    required this.roomId,
    required this.subcategoryName,
    required this.bookedDate,
    required this.isDraft,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
  });
  late final int id;
  late final int itemId;
  late final String itemName;
  late final String itemPrice;
  int? itemQuantity;
  late final String itemExpectedTime;
  late final int roomId;
  late final String subcategoryName;
  late final String bookedDate;
  late final bool isDraft;
  late final String createdAt;
  late final String updatedAt;
  late final int orderId;

  ItemOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemQuantity = json['item_quantity'];
    itemExpectedTime = json['item_expected_time'];
    roomId = json['room_id'];
    subcategoryName = json['subcategory_name'];
    bookedDate = json['booked_date'];
    isDraft = json['is_draft'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    data['item_quantity'] = itemQuantity;
    data['item_expected_time'] = itemExpectedTime;
    data['room_id'] = roomId;
    data['subcategory_name'] = subcategoryName;
    data['booked_date'] = bookedDate;
    data['is_draft'] = isDraft;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['orderId'] = orderId;
    return data;
  }
}
