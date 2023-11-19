/* class TableModel {
  TableModel({
    required this.tableName,
    required this.userName,
    required this.pax,
    required this.note,
  });
  late final String tableName;
  late final String userName;
  late final String pax;
  late final String note;

  TableModel.fromJson(Map<String, dynamic> json) {
    tableName = json['tableName'];
    userName = json['userName'];
    pax = json['pax'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tableName'] = tableName;
    data['userName'] = userName;
    data['pax'] = pax;
    data['note'] = note;
    return data;
  }
}
 */

import 'package:intl/intl.dart';

class TableModel {
  TableModel(
      {required this.reservationId,
      required this.startTime,
      required this.endTime,
      required this.identifier,
      required this.guestName,
      required this.contactNo,
      required this.notes,
      required this.bookedTables,
      required this.status,
      required this.pax,
      required this.paymentStatus,
      required this.balanceAmount,
      required this.completed,
      required this.diningType,
      required this.created,
      required this.createdTime,
      required this.orders,
      this.tableSelected = const []});
  late final int reservationId;
  late final String startTime;
  late final String endTime;
  late final String identifier;
  late final String guestName;
  late final String contactNo;
  late final String notes;
  late final String bookedTables;
  late final String status;
  late final String pax;
  late final String paymentStatus;
  late final String balanceAmount;
  late final bool completed;
  List<TableSelected> tableSelected = [];
  late final String created;
  late final String createdTime;
  late final String uniqueId;
  late final String diningType;
  late final int id;
  late final List<Orders> orders;

  TableModel.fromJson(Map<String, dynamic> json) {
    reservationId = json['reservation_id'] ?? 0;
    uniqueId = json['unique_id'] ?? "";
    id = json['id'] ?? 0;
    startTime = json['start_time'] != null
        ? ((json['start_time']?.toString().contains("T") ?? false)
            ? DateFormat("dd MMM hh:mm a")
                .format(DateTime.parse(json['start_time']))
            : json['start_time'])
        : "";
    endTime = json['end_time'];
    identifier = json['identifier'];
    guestName = json['guest_name'] ?? "";
    contactNo = json['contact_no'] ?? "";
    notes = json['notes'] ?? "";
    bookedTables = json['booked_tables'] ?? "-";
    status = json['status'] ?? "";
    pax = json['pax'] ?? "-";
    paymentStatus = json['payment_status'] ?? "";
    balanceAmount = json['balance_amount'] ?? "";
    completed = json['completed'] ?? false;
    tableSelected = List.from(json['tables_selected'] ?? [])
        .map((e) => TableSelected.fromJson(e))
        .toList();
    created = json['created_at'] != null
        ? ((json['created_at']?.toString().contains("T") ?? false)
            ? DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(json['created_at']))
            : json['created_at'])
        : "";
    createdTime = json['created_at'] != null
        ? ((json['created_at']?.toString().contains("T") ?? false)
            ? DateFormat("hh:mm a").format(DateTime.parse(json['created_at']))
            : "-")
        : "";
    diningType = json["dining_type"] ?? "";

    orders = json['orders'] != null
        ? List.from(json['orders']).map((e) => Orders.fromJson(e)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['reservation_id'] = reservationId;
    data['start_time'] = startTime;
    data['unique_id'] = uniqueId;
    data['id'] = id;
    data['end_time'] = endTime;
    data['identifier'] = identifier;
    data['guest_name'] = guestName;
    data['contact_no'] = contactNo;
    data['notes'] = notes;
    data['booked_tables'] = bookedTables;
    data['status'] = status;
    data['pax'] = pax;
    data['payment_status'] = paymentStatus;
    data['balance_amount'] = balanceAmount;
    data['completed'] = completed;
    data["created_at"] = created;
    data["dining_type"] = diningType;
    data['tables_selected'] = tableSelected.map((e) => e.toJson()).toList();
    data['orders'] = orders.map((e) => e.toJson()).toList();
    return data;
  }
}

class TableSelected {
  TableSelected(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.reservationId,
      required this.tableId,
      required this.waiterId,
      required this.spaceId,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.reservedTableId,
      required this.tableName});
  late final int id;
  late final String startTime;
  late final String endTime;
  late final int reservationId;
  late final int tableId;
  late final int waiterId;
  late final int spaceId;
  late final String status;
  late final String createdAt;
  late final String updatedAt;
  late final int reservedTableId;
  late final String tableName;

  TableSelected.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    reservationId = json['reservation_id'];
    tableId = json['table_id'];
    waiterId = json["waiter_id"] ?? 0;
    spaceId = json['space_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'];
    tableName = json["table_name"];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['start_time'] = startTime;
    datas['end_time'] = endTime;
    datas['reservation_id'] = reservationId;
    datas['table_id'] = tableId;
    datas['waiter_id'] = waiterId;
    datas['space_id'] = spaceId;
    datas['status'] = status;
    datas['created_at'] = createdAt;
    datas['updated_at'] = updatedAt;
    datas['reservedTableId'] = reservedTableId;
    datas["table_name"] = tableName;
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

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    tableId = json['table_id'] ?? 0;
    waiterId = json['waiter_id'] ?? 0;
    diningType = json['dining_type'];
    deliveryPartner = json['delivery_partner'];
    isDraft = json['is_draft'];
    completed = json['completed'];
    completedWhen = json['completed_when'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reservedTableId = json['reservedTableId'];
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
    return datas;
  }
}
