part of 'reservations_bloc.dart';

abstract class ReservationsState {}

class ReservationsInitial extends ReservationsState {}

class ReservationsLoad extends ReservationsState {}

class ReservationsError extends ReservationsState {
  final String errorMsg;

  ReservationsError(this.errorMsg);
}

class ReservationDetailsDone extends ReservationsState {
  final ReservationsDetailsModel reservationList;

  ReservationDetailsDone(this.reservationList);
}

class ReservationNodata extends ReservationsState {}

class ReservationActionLoad extends ReservationsState {}

class ReservationActionDone extends ReservationsState {
  ReservationActionDone();
}

class ReservationActionError extends ReservationsState {
  final String error;

  ReservationActionError(this.error);
}

class PaynowLoad extends ReservationsState {}

class PaynowDone extends ReservationsState {
  PaynowDone();
}

class PaynowError extends ReservationsState {}

class SplitLoad extends ReservationsState {}

class SplitDone extends ReservationsState {
  SplitDone();
}

class SplitError extends ReservationsState {}

class PrintLoad extends ReservationsState {}

class PrintDone extends ReservationsState {
  PrintDone();
}

class PrintError extends ReservationsState {}

class MarkLoad extends ReservationsState {}

class MarkDone extends ReservationsState {
  MarkDone();
}

class MarkError extends ReservationsState {}

class SwapLoad extends ReservationsState {}

class SwapDone extends ReservationsState {
  SwapDone();
}

class SwapError extends ReservationsState {}
