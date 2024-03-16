import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/availableTables_model.dart';
import 'package:hotelpro_mobile/models/edittable_request.dart';
import 'package:hotelpro_mobile/models/leveltable_model.dart';
import 'package:hotelpro_mobile/models/space_model.dart';
import 'package:hotelpro_mobile/repository/table_repo.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/table_model.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final TableDone tableDone = TableDone();
  TableBloc() : super(TableInitial()) {
    on<FetchTables>((event, emit) async {
      emit(TableLoad());
      try {
        log(event.type);
        SharedPreferences pref = await SharedPreferences.getInstance();
        String waiterId = pref.getString("userId") ?? "";
        List<TableModel> items = await TablesRepository()
            .data(type: event.type, nonDiner: event.nonDiner);

        items.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        if (event.type != "upcoming" &&
            event.type != "past" &&
            event.type != "current" &&
            event.type != "takeaway" &&
            event.type != "delivery") {
          items = items.where((element) => element.status != "").toList();
        }

        if (items.isNotEmpty) {
          if (event.type == "mytable") {
            items = items
                .where((element) => element.tableSelected
                    .where((e) => e.waiterId.toString() == waiterId)
                    .toList()
                    .isNotEmpty)
                .toList();

            items = items.map((e) {
              e.tableSelected = e.tableSelected
                  .where((element) => element.waiterId.toString() == waiterId)
                  .toList();
              return e;
            }).toList();
            emit(tableDone
              ..tables = items
              ..filterTables = items);
          } else if (event.type == "unassigned") {
            items = items
                .where((element) => element.tableSelected
                    .where((e) => e.waiterId == 0)
                    .toList()
                    .isNotEmpty)
                .toList();

            items = items.map((e) {
              e.tableSelected = e.tableSelected
                  .where((element) => element.waiterId == 0)
                  .toList();
              return e;
            }).toList();
            emit(tableDone
              ..tables = items
              ..filterTables = items);
          } else {
            emit(tableDone
              ..tables = items
              ..filterTables = items);
          }
        } else {
          emit(tableDone
            ..tables = items
            ..filterTables = items);
        }
      } catch (e) {
        log(e.toString());
        if (e == "204") {
          emit(TableNodata());
        } else {
          log(e.toString());
          emit(TableError());
        }
      }
    });

    on<AssignTables>((event, emit) async {
      emit(AssignLoad());
      try {
        var items = await TablesRepository().assign(event.id, event.tableId);

        emit(AssignDone());
      } catch (e) {
        log(e.toString());
        if (e == "204") {
          emit(AssignError());
        } else {
          log(e.toString());
          emit(AssignError());
        }
      }
    });

    on<CloseReservation>((event, emit) async {
      emit(AssignLoad());
      try {
        Response items = await TablesRepository().close(event.id,
            close: event.close,
            open: event.open,
            nonDiner: event.nonDiner,
            nonDiveResrvid: event.nonDiveResrvid);
        print(json.decode(items.body)["message"]);

        emit(AssignDone());
      } catch (e) {
        if (e == "204") {
          emit(AssignError());
        } else {
          emit(AssignError());
        }
      }
    });

    on<PrintKotEvent>((event, emit) async {
      emit(PrintKotLoad());
      try {
        var items = await TablesRepository()
            .printKot(event.id, event.waiterId, kot: event.kot);

        emit(PrintKotDone());
      } catch (e) {
        if (e == "204") {
          emit(PrintKotError("No Orders"));
        } else {
          emit(PrintKotError(e.toString()));
        }
      }
    });

    on<FetchLeveltable>((event, emit) async {
      emit(LeveltableLoad());
      try {
        var items =
            await TablesRepository().getLeveltables(event.time, event.levelId);

        emit(LeveltableDone(items));
      } catch (e) {
        log(e.toString());
        if (e == "204") {
          emit(LeveltableError(e.toString()));
        } else {
          log(e.toString());
          emit(LeveltableError(e.toString()));
        }
      }
    });

    on<FetchSpaces>((event, emit) async {
      emit(SpaceLoad());
      try {
        var items = await TablesRepository().getSpaces();

        emit(SpaceDone(items));
      } catch (e) {
        log(e.toString());
        if (e == "204") {
          emit(SpaceError(e.toString()));
        } else {
          log(e.toString());
          emit(SpaceError(e.toString()));
        }
      }
    });

    on<FilterTables>((event, emit) async {
      emit(TableLoad());
      try {
        List<TableModel> issueList = List.from(tableDone.tables);

        if (event.searchText.isNotEmpty) {
          issueList.retainWhere((element) => (element.guestName
                  .toLowerCase()
                  .contains(event.searchText.toLowerCase()) ||
              element.identifier
                  .toLowerCase()
                  .contains(event.searchText.toLowerCase()) ||
              element.contactNo
                  .toLowerCase()
                  .contains(event.searchText.toLowerCase())));
        }
        if (event.date.isNotEmpty) {
          log(filterItemsByDate(issueList, DateTime.parse(event.date))
              .length
              .toString());
          issueList = filterItemsByDate(issueList, DateTime.parse(event.date));
        }

        if (event.fromTime != null && event.toTime == null) {
          issueList = filterItemsByFromTime(issueList, event.fromTime!);
        }

        if (event.toTime != null && event.fromTime == null) {
          issueList = filterItemsByToTime(issueList, event.toTime!);
        }

        if (event.fromTime != null && event.toTime != null) {
          issueList = issueList.where((item) {
            // Convert item's time to minutes for comparison
            int itemMinutes = parseDateTime(item.startTime).hour * 60 +
                parseDateTime(item.startTime).minute;
            int fromTimeMinutes =
                event.fromTime!.hour * 60 + event.fromTime!.minute;
            int toTimeMinutes = event.toTime!.hour * 60 + event.toTime!.minute;

            // Check if item's time falls within the specified range
            return itemMinutes >= fromTimeMinutes &&
                itemMinutes <= toTimeMinutes;
          }).toList();
        }

        emit(tableDone..filterTables = issueList);
      } catch (e) {
        emit(TableError());
      }
    });

    on<GetTables>((event, emit) async {
      emit(TableLoad());
      try {
        final response = await TablesRepository().getTables();

        emit(GetTablesDone(response));
      } catch (e) {
        emit(TableError());
        throw ("error");
      }
    });

    on<CreateTables>((event, emit) async {
      emit(CreateLoad());
      try {
        final response = await TablesRepository().create(event.request,id:event.id);

        emit(CreatedDone());
      } catch (e) {
        emit(CreateError());
      }
    });

    on<DeleteTables>((event, emit) async {
      emit(CreateLoad());
      try {
        final response = await TablesRepository().delete(event.id);

        emit(CreatedDone());
      } catch (e) {
        emit(CreateError());
      }
    });
  }

  DateTime parseDateTime(String dateTimeString) {
    // Parse the date and time
    DateFormat dateFormat = DateFormat("dd MMM hh:mm a");
    DateTime dateTime = dateFormat.parse(dateTimeString);

    // Adjust the time to match AM/PM format
    if (dateTime.hour == 12 && dateTimeString.endsWith("AM")) {
      dateTime = dateTime.subtract(const Duration(hours: 12));
    } else if (dateTime.hour < 12 && dateTimeString.endsWith("PM")) {
      dateTime = dateTime.add(const Duration(hours: 12));
    }

    return dateTime;
  }

  List<TableModel> filterItemsByDate(
      List<TableModel> items, DateTime targetDate) {
    return items.where((item) {
      print(item.startTime);
      return isSameDay(parseDateTime(item.startTime), targetDate);
    }).toList();
  }

  DateTime parseDate(String dateTimeString) {
    // Parse the string into a DateTime object
    DateFormat dateFormat = DateFormat("dd MMM hh:mm a");
    return dateFormat.parse(dateTimeString);
  }

  bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    print("$dateTime1 -- $dateTime2");
    return dateTime1.month == dateTime2.month && dateTime1.day == dateTime2.day;
  }

  List<TableModel> filterItemsByFromTime(
      List<TableModel> items, TimeOfDay fromTime) {
    return items.where((item) {
      // Convert item's time to minutes for comparison
      int itemMinutes = parseDateTime(item.startTime).hour * 60 +
          parseDateTime(item.startTime).minute;
      int fromTimeMinutes = fromTime.hour * 60 + fromTime.minute;

      // Check if item's time is greater than or equal to the "from time"
      return itemMinutes >= fromTimeMinutes;
    }).toList();
  }

  List<TableModel> filterItemsByToTime(
      List<TableModel> items, TimeOfDay toTime) {
    return items.where((item) {
      // Convert item's time to minutes for comparison
      int itemMinutes = parseDateTime(item.startTime).hour * 60 +
          parseDateTime(item.startTime).minute;
      int toTimeMinutes = toTime.hour * 60 + toTime.minute;

      // Check if item's time is less than or equal to the "to time"
      return itemMinutes <= toTimeMinutes;
    }).toList();
  }

  void dispose() {
    TableBloc().dispose();
  }
}
