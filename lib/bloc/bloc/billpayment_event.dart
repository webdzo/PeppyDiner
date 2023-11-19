part of 'billpayment_bloc.dart';

class BillpaymentEvent {}

class FetchService extends BillpaymentEvent {
  final String id;
  FetchService({this.id = "0"});
}

class FetchDiscount extends BillpaymentEvent {
  FetchDiscount();
}

class FetchPayments extends BillpaymentEvent {
  FetchPayments();
}

class FetchBill extends BillpaymentEvent {
  final String id;
  FetchBill(this.id);
}

class UpdateBill extends BillpaymentEvent {
  final BillupdateRequest request;
  final String id;
  UpdateBill(this.request, this.id);
}
