part of 'reservations_bloc.dart';

abstract class ReservationsEvent {}

class FetchReservation extends ReservationsEvent {
  FetchReservation();
}

class ReservationDetailsEvent extends ReservationsEvent {
  final int id;
  ReservationDetailsEvent(this.id);
}

class ReservationActions extends ReservationsEvent {
  final int reservationId;
  final int statusId;
  ReservationActions(this.reservationId, {this.statusId = 0});
}

class PaynowEvent extends ReservationsEvent {
  final String id;
  final String amount;

  PaynowEvent(this.id, this.amount);
}

class ResendmailEvent extends ReservationsEvent {
  final String id;

  ResendmailEvent(this.id);
}

class EditdiscountEvent extends ReservationsEvent {
  final String id;
  final String discount;

  EditdiscountEvent(this.id, this.discount);
}

class DeleteroomEvent extends ReservationsEvent {
  final String id;
  final TablesSelected room;

  DeleteroomEvent(this.id, this.room);
}

class EditCountEvent extends ReservationsEvent {
  final String id;
  final dynamic count;

  EditCountEvent(this.id, this.count);
}
