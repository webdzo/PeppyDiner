abstract class AvailableRoomsEvent {}

class FetchAvailableRooms extends AvailableRoomsEvent {
  final String startDate;
  final String endDate;
  FetchAvailableRooms(this.startDate, this.endDate);
}

class FetchRooms extends AvailableRoomsEvent {
  FetchRooms();
}
