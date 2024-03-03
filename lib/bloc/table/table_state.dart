part of 'table_bloc.dart';

abstract class TableState {}

class TableInitial extends TableState {}

class TableLoad extends TableState {}

class TableDone extends TableState {
  List<TableModel> tables = [];

  List<TableModel> filterTables = [];

  TableDone();
}

class TableError extends TableState {}

class TableNodata extends TableState {}

class AssignLoad extends TableState {}

class AssignDone extends TableState {
  AssignDone();
}

class AssignError extends TableState {}

class PrintKotLoad extends TableState {}

class PrintKotDone extends TableState {
  PrintKotDone();
}

class PrintKotError extends TableState {
  final String errorMessage;
  PrintKotError(this.errorMessage);
}

class LeveltableLoad extends TableState {}

class LeveltableDone extends TableState {
  final LeveltableModel tables;
  LeveltableDone(this.tables);
}

class LeveltableError extends TableState {
  final String errorMessage;
  LeveltableError(this.errorMessage);
}

class SpaceLoad extends TableState {}

class SpaceDone extends TableState {
  final List<SpaceModel> spaces;
  SpaceDone(this.spaces);
}

class SpaceError extends TableState {
  final String errorMessage;
  SpaceError(this.errorMessage);
}
