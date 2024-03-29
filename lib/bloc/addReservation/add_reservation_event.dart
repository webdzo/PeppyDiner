import '../../models/addReserv_request.dart';

abstract class AddreservationEvent {}

class Addreservation extends AddreservationEvent {
  final AddReservRequest request;
  final bool? edit;
  final bool? addGuest;
  final String? id;
  final String? guestId;
  Addreservation(this.request,
      {this.edit, this.addGuest, this.id, this.guestId});
}

class Updatereservation extends AddreservationEvent {
  final AddReservRequest request;
  final int id;
  Updatereservation(this.request, this.id);
}

class UpdateGuest extends AddreservationEvent {
  final Map<String, String> request;
  final int id;
  UpdateGuest(this.request, this.id);
}

class GetoccasionsEvent extends AddreservationEvent {
  GetoccasionsEvent();
}

class GetpackagesEvent extends AddreservationEvent {
  GetpackagesEvent();
}

class GetcakesEvent extends AddreservationEvent {
  GetcakesEvent();
}

class GetusersEvent extends AddreservationEvent {
  GetusersEvent();
}

class UpdateGuestcount extends AddreservationEvent {
  final String count;
  final int id;
  UpdateGuestcount(this.count, this.id);
}
