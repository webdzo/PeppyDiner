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
  final List<UpdatemodeRequest> amount;

  PaynowEvent(this.id, this.amount);
}

class SplitEvent extends ReservationsEvent {
  final String id;
  final String splitdata;

  SplitEvent(this.id, this.splitdata);
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

class PrintEvent extends ReservationsEvent {
  final String id;

  PrintEvent(this.id);
}

class MarkUpdate extends ReservationsEvent {
  final String id;
  final String status;

  MarkUpdate(this.id, this.status);
}

class SwapEvent extends ReservationsEvent {
  final String id;
  final String oldid;
  final String newid;

  SwapEvent(this.id, this.oldid, this.newid);
}

class BackdateEvent extends ReservationsEvent {
  final String date;
  final String id;
  BackdateEvent(this.id, this.date);
}
