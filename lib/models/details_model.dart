class DetailsModel {
  DetailsModel({
    required this.reservation,
  });
  late final Reservation reservation;

  DetailsModel.fromJson(Map<String, dynamic> json) {
    reservation = Reservation.fromJson(json['reservation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['reservation'] = reservation.toJson();
    return data;
  }
}

class Reservation {
  Reservation(
      {required this.id,
      required this.uniqueId,
      required this.identifier,
      required this.startTime,
      required this.endTime,
      required this.notes,
      required this.totalHeads,
      required this.event,
      required this.totalPayment,
      required this.flatDiscount,
      required this.balanceAmount,
      required this.commission,
      required this.advancePaid,
      required this.cake,
      required this.quantity,
      required this.occasion,
      required this.package,
      required this.completed,
      required this.status,
      required this.paymentStatus,
      required this.diningType,
      required this.paymentMode,
      required this.openedWhen,
      required this.allocatedWhen,
      required this.closedWhen,
      required this.createdAt,
      required this.updatedAt,
      required this.user,
      required this.tablesSelected,
      required this.taxGst,
      required this.companyDetails,
      required this.invoice,
      required this.orders});
  late final int id;
  late final String uniqueId;
  late final String identifier;
  late final String startTime;
  late final String endTime;
  late final String notes;
  late final String totalHeads;
  late final String event;
  late final String totalPayment;
  late final String flatDiscount;
  late final String balanceAmount;
  late final String commission;
  late final String advancePaid;
  late final Cake cake;
  late final String quantity;
  late final Occasion occasion;
  late final Package package;
  late final bool completed;
  late final String status;
  late final String paymentStatus;
  late final String diningType;
  late final String paymentMode;
  late final String openedWhen;
  late final String allocatedWhen;
  late final String closedWhen;
  late final String createdAt;
  late final String updatedAt;
  late final User user;
  late final List<TablesSelected> tablesSelected;
  late final TaxGst taxGst;
  late final String companyDetails;
  late final List<Invoice> invoice;
  late final List<Orders> orders;

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    identifier = json['identifier'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    notes = json['notes'] ?? "";
    totalHeads = json['total_heads'];
    event = json['event'] ?? "";
    totalPayment = json['total_payment'];
    flatDiscount = json['flat_discount'];
    balanceAmount = json['balance_amount'];
    commission = json['commission'];
    advancePaid = json['advance_paid'];
    cake = Cake.fromJson(json['cake'] ?? {});
    quantity = json['quantity'] ?? "";
    occasion = Occasion.fromJson(json['occasion']);
    package = Package.fromJson(json['package']);
    completed = json['completed'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    diningType = json['dining_type'];
    paymentMode = json['payment_mode'] ?? "";
    openedWhen = json['opened_when'] ?? "";
    allocatedWhen = json['allocatedWhen'] ?? "";
    closedWhen = json['closedWhen'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    user = User.fromJson(json['user']);
    tablesSelected = List.from(json['tables_selected'])
        .map((e) => TablesSelected.fromJson(e))
        .toList();
    taxGst = TaxGst.fromJson(json['tax_gst']);
    companyDetails = json["companyDetails"] ?? "";
    invoice =
        List.from(json['invoice']).map((e) => Invoice.fromJson(e)).toList();
    orders = json['orders'] == null
        ? []
        : List.from(json['orders'] ?? [])
            .map((e) => Orders.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['unique_id'] = uniqueId;
    data['identifier'] = identifier;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['notes'] = notes;
    data['total_heads'] = totalHeads;
    data['event'] = event;
    data['total_payment'] = totalPayment;
    data['flat_discount'] = flatDiscount;
    data['balance_amount'] = balanceAmount;
    data['commission'] = commission;
    data['advance_paid'] = advancePaid;
    data['cake'] = cake.toJson();
    data['quantity'] = quantity;
    data['occasion'] = occasion.toJson();
    data['package'] = package.toJson();
    data['completed'] = completed;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['dining_type'] = diningType;
    data['payment_mode'] = paymentMode;
    data['opened_when'] = openedWhen;
    data['allocated_when'] = allocatedWhen;
    data['closed_when'] = closedWhen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user.toJson();
    data['tables_selected'] = tablesSelected.map((e) => e.toJson()).toList();
    data['tax_gst'] = taxGst.toJson();
    data['company_details'] = companyDetails;
    data['invoice'] = invoice.map((e) => e.toJson()).toList();
    data['orders'] = orders.map((e) => e.toJson()).toList();
    return data;
  }
}

class Orders {
  Orders({
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

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    tableId = json['table_id'] ?? 0;
    diningType = json['dining_type'];
    deliveryPartner = json['delivery_partner'] ?? "";
    isDraft = json['is_draft'] ?? false;
    completed = json['completed'];
    completedWhen = json['completed_when'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'];
    itemOrders = List.from(json['item_orders'])
        .map((e) => ItemOrders.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['table_id'] = tableId;
    data['dining_type'] = diningType;
    data['delivery_partner'] = deliveryPartner;
    data['is_draft'] = isDraft;
    data['completed'] = completed;
    data['completed_when'] = completedWhen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reservedTableId'] = reservedTableId;
    data['item_orders'] = itemOrders.map((e) => e.toJson()).toList();
    return data;
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

class Cake {
  Cake({
    required this.name,
    required this.id,
    required this.price,
  });
  late final String name;
  late final int id;
  late final String price;

  Cake.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    id = json['id'] ?? 0;
    price = json['price'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['price'] = price;
    return data;
  }
}

class Occasion {
  Occasion({
    required this.id,
    required this.name,
    required this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
  });
  late final int id;
  late final String name;
  late final String parentId;
  late final String createdAt;
  late final String updatedAt;
  late final String reservedTableId;

  Occasion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parentId'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reservedTableId'] = reservedTableId;
    return data;
  }
}

class Package {
  Package({
    required this.id,
    required this.name,
    required this.parentId,
    required this.benefits,
    required this.cost,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
  });
  late final int id;
  late final String name;
  late final String parentId;
  late final String benefits;
  late final String cost;
  late final String createdAt;
  late final String updatedAt;
  late final String reservedTableId;

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'] ?? "";
    benefits = json['benefits'];
    cost = json['cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json["reservedTableId"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['benefits'] = benefits;
    data['cost'] = cost;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reservedTableId'] = reservedTableId;
    return data;
  }
}

class User {
  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final String address;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json["address"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    return data;
  }
}

class TablesSelected {
  TablesSelected({
    required this.id,
    required this.name,
    required this.category,
    required this.floor,
    required this.occupancy,
    required this.categoryName,
  });
  late final int id;
  late final String name;
  late final int category;
  late final String floor;
  late final String occupancy;
  late final String categoryName;

  TablesSelected.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    floor = json['floor'];
    occupancy = json['occupancy'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['floor'] = floor;
    data['occupancy'] = occupancy;
    data['category_name'] = categoryName;
    return data;
  }
}

class TaxGst {
  TaxGst({
    required this.id,
    required this.tax,
    required this.gst,
    required this.gstin,
    required this.option,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String tax;
  late final String gst;
  late final String gstin;
  late final int option;
  late final String createdAt;
  late final String updatedAt;

  TaxGst.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tax = json['tax'];
    gst = json['gst'];
    gstin = json['gstin'];
    option = json['option'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['tax'] = tax;
    data['gst'] = gst;
    data['gstin'] = gstin;
    data['option'] = option;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Invoice {
  Invoice({
    required this.id,
    required this.invoiceNo,
    required this.reservationId,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
  });
  late final int id;
  late final String invoiceNo;
  late final String reservationId;
  late final String createdAt;
  late final String updatedAt;
  late final String reservedTableId;

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNo = json['invoice_no'];
    reservationId = json['reservationId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json["reservedTableId"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['invoice_no'] = invoiceNo;
    datas['reservationId'] = reservationId;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    return datas;
  }
}
