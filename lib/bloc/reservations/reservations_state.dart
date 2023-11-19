part of 'reservations_bloc.dart';

abstract class ReservationsState {}

class ReservationsInitial extends ReservationsState {}

class ReservationsLoad extends ReservationsState {}



class ReservationsError extends ReservationsState {}

class ReservationDetailsDone extends ReservationsState {
  final ReservationsDetailsModel reservationList;

  ReservationDetailsDone(this.reservationList);
}

class ReservationError extends ReservationsState {}

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
