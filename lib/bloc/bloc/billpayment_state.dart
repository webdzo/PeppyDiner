part of 'billpayment_bloc.dart';

class BillpaymentState {}

class BillpaymentInitial extends BillpaymentState {}

class ServiceLoad extends BillpaymentState {}

class ServiceDone extends BillpaymentState {
  final List<ServicechargeModel> charges;

  ServiceDone(this.charges);
}

class ServiceError extends BillpaymentState {}

class DiscountLoad extends BillpaymentState {}

class DiscountDone extends BillpaymentState {
  final List<DiscountModel> discounts;

  DiscountDone(this.discounts);
}

class DiscountError extends BillpaymentState {}

class PaymentsLoad extends BillpaymentState {}

class PaymentsDone extends BillpaymentState {
  final List<PaymentsModel> payments;

  PaymentsDone(this.payments);
}

class PaymentsError extends BillpaymentState {}

class BillLoad extends BillpaymentState {}

class BillDone extends BillpaymentState {
  final BillpaymentModel bill;

  BillDone(this.bill);
}

class BillError extends BillpaymentState {}

class UpdateLoad extends BillpaymentState {}

class UpdateDone extends BillpaymentState {}

class UpdateError extends BillpaymentState {}
