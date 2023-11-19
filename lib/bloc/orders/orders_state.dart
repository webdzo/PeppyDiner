part of 'orders_bloc.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoad extends OrdersState {}

class OrdersDone extends OrdersState {
  final List<OrderlistModel> orders;

  OrdersDone(this.orders);
}

class AddOrdersLoad extends OrdersState {}

class AddOrdersError extends OrdersState {}

class AddOrdersDone extends OrdersState {
  AddOrdersDone();
}

class OrdersError extends OrdersState {}

class EditOrdersLoad extends OrdersState {}

class EditOrdersDone extends OrdersState {
  EditOrdersDone();
}

class EditOrdersError extends OrdersState {}

class EditOrdersNodata extends OrdersState {}

class GetnameLoad extends OrdersState {}

class GetnameDone extends OrdersState {
  final UsernameModel data;

  GetnameDone(this.data);
}

class GetnameError extends OrdersState {}
