part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class FetchOrders extends OrdersEvent {
  final int id;
  final int tableId;
  FetchOrders(this.id, this.tableId);
}

class AddOrders extends OrdersEvent {
  final AddOrdersRequest addOrdersRequest;
  AddOrders(this.addOrdersRequest);
}

class AddItems extends OrdersEvent {
  final String orderId;
  final AddItemsRequest additemsRequest;
  AddItems(this.additemsRequest, this.orderId);
}

class EditOrders extends OrdersEvent {
  final String orderId;
  final String itemId;
  final String quanity;
  final String notes;
  EditOrders(
    this.orderId,
    this.itemId,
    this.quanity, this.notes,
  );
}

class DeleteItem extends OrdersEvent {
  final String orderId;
  final String itemId;

  DeleteItem(
    this.orderId,
    this.itemId,
  );
}

class DeleteOrder extends OrdersEvent {
  final String orderId;

  DeleteOrder(
    this.orderId,
  );
}

class GetUsername extends OrdersEvent {
  final int id;

  GetUsername(this.id);
}
