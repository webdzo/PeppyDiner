class ReservationsDetailsModel {
  ReservationsDetailsModel({
    required this.reservation,
  });
  late final Reservation reservation;

  ReservationsDetailsModel.fromJson(Map<String, dynamic> json) {
    reservation = Reservation.fromJson(json['reservation']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['reservation'] = reservation.toJson();
    return datas;
  }
}

class Reservation {
  Reservation({
    required this.id,
    required this.uniqueId,
    required this.identifier,
    required this.startTime,
    required this.endTime,
    required this.notes,
    required this.totalHeads,
    required this.event,
    required this.totalPayment,
    required this.taxGst,
    required this.flatDiscount,
    required this.serviceCharge,
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
    required this.companyDetails,
    required this.invoice,
  });
  late final int id;
  late final String uniqueId;
  late final String identifier;
  late final String startTime;
  late final String endTime;
  late final String notes;
  late final String totalHeads;
  late final String event;
  late final String totalPayment;
  late final int taxGst;
  late final int flatDiscount;
  late final int serviceCharge;
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
  late final List<Orders> orders;
  late final List<TablesSelected> tablesSelected;
  late final List<BookedTables> bookedTables;
  late final CompanyDetails companyDetails;
  late final List<Invoice> invoice;

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    identifier = json['identifier'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    notes = json['notes'] ?? "";
    totalHeads = json['total_heads'] ?? "";
    event = json["event"] ?? "";
    totalPayment = json['total_amount']?.toString() ?? "0";
    taxGst = json["taxGst"] ?? 0;
    //taxGst = TaxGst.fromJson(json['tax_gst'] ?? {});
    flatDiscount = json['flat_discount'] ?? 0;
    serviceCharge = json['service_charge'] ?? 0;
    balanceAmount = json['balance_amount']?.toString() ?? "0";
    commission = json['commission'] ?? "0";
    advancePaid = json['advance_paid'] ?? "0";
    cake = Cake.fromJson(json['cake'] ?? {});
    quantity = json['quantity'] ?? "";
    occasion = Occasion.fromJson(json['occasion'] ?? {});
    package = Package.fromJson(json['package'] ?? {});
    completed = json['completed'] ?? false;
    status = json['status'];
    paymentStatus = json['payment_status'] ?? "";
    diningType = json['dining_type'] ?? "";
    paymentMode = json["payment_mode"] ?? "";
    openedWhen = json["opened_when"] ?? "";
    allocatedWhen = json["allocated_when"] ?? "";
    closedWhen = json["closed_when"] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = User.fromJson(json['user'] ?? {});
    orders =
        List.from(json['orders'] ?? []).map((e) => Orders.fromJson(e)).toList();
    tablesSelected = List.from(json['tables_selected'])
        .map((e) => TablesSelected.fromJson(e))
        .toList();
    bookedTables = List.from(json['booked_tables'])
        .map((e) => BookedTables.fromJson(e))
        .toList();
    companyDetails = CompanyDetails.fromJson(json['company_details']);
    invoice =
        List.from(json['invoice']).map((e) => Invoice.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['unique_id'] = uniqueId;
    datas['identifier'] = identifier;
    datas['start_time'] = startTime;
    datas['end_time'] = endTime;
    datas['notes'] = notes;
    datas['total_heads'] = totalHeads;
    datas['event'] = event;
    datas['total_payment'] = totalPayment;
    datas['tax_gst'] = taxGst;
    datas['flat_discount'] = flatDiscount;
    datas['service_charge'] = serviceCharge;
    datas['balance_amount'] = balanceAmount;
    datas['commission'] = commission;
    datas['advance_paid'] = advancePaid;
    datas['cake'] = cake.toJson();
    datas['quantity'] = quantity;
    datas['occasion'] = occasion.toJson();
    datas['package'] = package.toJson();
    datas['completed'] = completed;
    datas['status'] = status;
    datas['payment_status'] = paymentStatus;
    datas['dining_type'] = diningType;
    datas['payment_mode'] = paymentMode;
    datas['opened_when'] = openedWhen;
    datas['allocated_when'] = allocatedWhen;
    datas['closed_when'] = closedWhen;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['user'] = user.toJson();
    datas['orders'] = orders.map((e) => e.toJson()).toList();
    datas['tables_selected'] = tablesSelected.map((e) => e.toJson()).toList();
    datas['booked_tables'] = bookedTables.map((e) => e.toJson()).toList();
    datas['company_details'] = companyDetails.toJson();
    datas['invoice'] = invoice.map((e) => e.toJson()).toList();
    return datas;
  }
}

class Orders {
  Orders({
    required this.id,
    required this.orderNo,
    required this.tableId,
    required this.waiterId,
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
  late final int waiterId;
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
    waiterId = json['waiter_id'] ?? 0;
    diningType = json['dining_type'];
    deliveryPartner = json['delivery_partner'] ?? "";
    isDraft = json['is_draft'];
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
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['order_no'] = orderNo;
    datas['table_id'] = tableId;
    datas['waiter_id'] = waiterId;
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
  int itemQuantity = 0;
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

class BookedTables {
  BookedTables({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.tableId,
    this.waiterId,
    required this.spaceId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.reservedTableId,
    required this.tableName,
  });
  late final int id;
  late final String startTime;
  late final String endTime;

  late final int tableId;
  late final int? waiterId;
  late final int spaceId;
  late final String status;
  late final String createdAt;
  late final String updatedAt;
  late final int reservedTableId;
  late final String tableName;

  BookedTables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'] ?? "";
    endTime = json['end_time'] ?? "";

    tableId = json['table_id'];
    waiterId = json['waiter_id'] ?? 0;
    spaceId = json['space_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'];
    tableName = json['table_name'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['start_time'] = startTime;
    datas['end_time'] = endTime;

    datas['table_id'] = tableId;
    datas['waiter_id'] = waiterId;
    datas['space_id'] = spaceId;
    datas['status'] = status;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    datas['table_name'] = tableName;
    return datas;
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
    id = json['id'] ?? 0;
    tax = json['tax'] ?? "";
    gst = json['gst'] ?? "";
    gstin = json['gstin'] ?? "";
    option = json['option'] ?? 0;
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['tax'] = tax;
    datas['gst'] = gst;
    datas['gstin'] = gstin;
    datas['option'] = option;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
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
    final datas = <String, dynamic>{};
    datas['name'] = name;
    datas['id'] = id;
    datas['price'] = price;
    return datas;
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
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    parentId = json["parent_id"] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    reservedTableId = json["reservedTableId"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['parent_id'] = parentId;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    return datas;
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
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    parentId = json["parent_id"] ?? "";
    benefits = json['benefits'] ?? "";
    cost = json['cost'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    reservedTableId = json["reservedTableId"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['parent_id'] = parentId;
    datas['benefits'] = benefits;
    datas['cost'] = cost;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    return datas;
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
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
    address = json['address'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['phone'] = phone;
    datas['email'] = email;
    datas['address'] = address;
    return datas;
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
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['category'] = category;
    datas['floor'] = floor;
    datas['occupancy'] = occupancy;
    datas['category_name'] = categoryName;
    return datas;
  }
}

class CompanyDetails {
  CompanyDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address_1,
    required this.address_2,
    required this.website,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String email;
  late final String phone;
  late final String address_1;
  late final String address_2;
  late final String website;
  late final String createdAt;
  late final String updatedAt;

  CompanyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address_1 = json['address_1'];
    address_2 = json['address_2'];
    website = json['website'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['name'] = name;
    datas['email'] = email;
    datas['phone'] = phone;
    datas['address_1'] = address_1;
    datas['address_2'] = address_2;
    datas['website'] = website;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    return datas;
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
