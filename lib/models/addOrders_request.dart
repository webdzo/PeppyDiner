import 'package:intl/intl.dart';

class AddOrdersRequest {
  AddOrdersRequest({this.data, this.currentTime});
  Data? data;
  String? currentTime;

  AddOrdersRequest.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
    currentTime = json["current_time"];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['data'] = data?.toJson();
    datas["current_time"] =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());
    return datas;
  }
}

class Data {
  Data({
    this.tableDetails,
    this.orders,
  });
  TableDetails? tableDetails;
  List<CartItems>? orders;

  Data.fromJson(Map<String, dynamic> json) {
    tableDetails = TableDetails.fromJson(json['table_details']);
    orders =
        List.from(json['orders']).map((e) => CartItems.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['table_details'] = tableDetails?.toJson();
    data['orders'] = orders?.map((e) => e.toJson()).toList();
    return data;
  }
}

class TableDetails {
  TableDetails(
      {required this.tableId,
      required this.reservationIdentifier,
      required this.diningType,
      required this.deliveryPartner,
      required this.isDraft,
      required this.waiterId,
      required this.notes});
  late final int tableId;
  late final String reservationIdentifier;
  late final String diningType;
  late final String deliveryPartner;
  late final int waiterId;
  late final bool isDraft;
  late final String notes;

  TableDetails.fromJson(Map<String, dynamic> json) {
    tableId = json['table_id'];
    reservationIdentifier = json['reservation_identifier'];
    diningType = json['dining_type'];
    deliveryPartner = json['delivery_partner'];
    isDraft = json["is_draft"];
    waiterId = json["waiter_id"];
    notes = json["notes"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['table_id'] = tableId;
    data['reservation_identifier'] = reservationIdentifier;
    data['dining_type'] = diningType;
    data['delivery_partner'] = deliveryPartner;
    data["is_draft"] = isDraft;
    data["waiter_id"] = waiterId;
    data["notes"] = notes;
    return data;
  }
}

class CartItems {
  CartItems({
    this.key,
    this.itemId,
    this.quantity,
    this.name,
    this.subCategory,
    this.price,
    this.eta,
    this.modifiedEta,
    this.split,
    this.category,
  });
  String? key;
  int? itemId;
  int? quantity;
  String? name;
  String? subCategory;
  String? price;
  String? eta;
  String? modifiedEta;
  bool? split;
  String? category;

  CartItems.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    name = json['name'];
    subCategory = json['subCategory'];
    price = json['price'];
/*     eta = json['eta'];
    modifiedEta = json['modified_eta'];
    split = json['split']; */
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['item_id'] = itemId;
    data['quantity'] = quantity;
    data['name'] = name;
    data['subCategory'] = subCategory;
    data['price'] = price;
/*     data['eta'] = eta;
    data['modified_eta'] = modifiedEta;
    data['split'] = split; */
    data['category'] = category;
    return data;
  }
}
