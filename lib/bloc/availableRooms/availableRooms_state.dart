
import '../../models/availableTables_model.dart';

abstract class AvailableRoomsState {}

class AvailableRoomsInitial extends AvailableRoomsState {}

class AvailableRoomsLoad extends AvailableRoomsState {}

class AvailableRoomsDone extends AvailableRoomsState {
  final AvailableTablesModel reservationList;

  AvailableRoomsDone(this.reservationList);
}

class AvailableRoomsError extends AvailableRoomsState {}
