part of 'table_bloc.dart';

abstract class TableEvent {}

class FetchTables extends TableEvent {
  final String type;
  final bool nonDiner;
  FetchTables(this.type, {this.nonDiner = false});
}

class FilterTables extends TableEvent {
  final String searchText;
  final String date;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;

  FilterTables(this.searchText, this.fromTime, this.toTime, this.date);
}

class AssignTables extends TableEvent {
  final String id;
  final List<int> tableId;
  AssignTables(this.id, this.tableId);
}

class CloseReservation extends TableEvent {
  final String id;
  final bool close;
  final bool open;
  final bool nonDiner;
  final int nonDiveResrvid;

  CloseReservation(this.id,
      {this.close = false,
      this.open = false,
      this.nonDiner = false,
      this.nonDiveResrvid = 0});
}

class PrintKotEvent extends TableEvent {
  final int id;
  final int waiterId;
  final bool kot;
  PrintKotEvent(this.id, this.waiterId, {this.kot = true});
}

class FetchLeveltable extends TableEvent {
  final String time;
  final int levelId;

  FetchLeveltable(this.time, this.levelId);
}

class FetchSpaces extends TableEvent {
  FetchSpaces();
}

class GetTables extends TableEvent {
  GetTables();
}

class CreateTables extends TableEvent {
  int? id;
  final EdittableRequest request;
  CreateTables(this.request, {this.id});
}
