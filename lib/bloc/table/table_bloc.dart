import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/leveltable_model.dart';
import 'package:hotelpro_mobile/models/space_model.dart';
import 'package:hotelpro_mobile/repository/table_repo.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/table_model.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableInitial()) {
    on<FetchTables>((event, emit) async {
      emit(TableLoad());
      try {
        log(event.type);
        SharedPreferences pref = await SharedPreferences.getInstance();
        String waiterId = pref.getString("userId") ?? "";
        List<TableModel> items = await TablesRepository()
            .data(type: event.type, nonDiner: event.nonDiner);
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
            emit(TableDone(items));
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
            emit(TableDone(items));
          } else {
            emit(TableDone(items));
          }
        } else {
          emit(TableDone(items));
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
  }

  void dispose() {
    TableBloc().dispose();
  }
}
