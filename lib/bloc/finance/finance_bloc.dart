import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/bycat_model.dart';
import 'package:hotelpro_mobile/models/bywaiter_model.dart';
import 'package:hotelpro_mobile/models/cancelorder_model.dart';
import 'package:hotelpro_mobile/models/deleted_item_model.dart';

import '../../models/add_exp_request.dart';
import '../../models/expense_cat_model.dart';
import '../../models/finance_model.dart';
import '../../models/itemstats_model.dart';
import '../../models/monthincome_model.dart';
import '../../models/timestats_model.dart';
import '../../repository/finance_repo.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc() : super(FinanceInitial()) {
    on<FetchFinance>((event, emit) async {
      emit(FinanceLoad());
      try {
        final financeList = await FinanceRepository().data();

        emit(FinanceDone(financeList));
      } catch (e) {
        if (e == "204") {
          emit(FinanceNodata());
        } else {
          emit(FinanceError());
          throw ("error");
        }
      }
    });

    on<FetchIncome>((event, emit) async {
      emit(IncomeLoad());
      try {
        final incomeData = await FinanceRepository().incomeData();

        emit(IncomeDone(incomeData));
      } catch (e) {
        if (e == "204") {
          emit(IncomeNodata());
        } else {
          emit(IncomeError());
          throw ("error");
        }
      }
    });

    on<AddExpenseEvent>((event, emit) async {
      emit(AddExpenseLoad());
      try {
        final response = await FinanceRepository().addExpense(event.request);

        emit(AddExpenseDone());
      } catch (e) {
        emit(AddExpenseError());
      }
    });

    on<FetchItemstats>((event, emit) async {
      emit(ItemstatsLoad());
      try {
        final incomeData = await FinanceRepository()
            .getItemstats(event.startDate, event.endDate);

        emit(ItemstatsDone(incomeData));
      } catch (e) {
        if (e == "204") {
          emit(ItemstatsError(e.toString()));
        } else {
          emit(ItemstatsError(e.toString()));
        }
      }
    });

    on<FetchTimestats>((event, emit) async {
      emit(TimestatsLoad());
      try {
        final incomeData = await FinanceRepository()
            .getTimestats(event.startDate, event.endDate);

        print("incomeData.length${incomeData.length}");
        emit(TimestatsDone(incomeData));
      } catch (e) {
        if (e == "204") {
          emit(TimestatsError());
        } else {
          emit(TimestatsError());
          throw ("error");
        }
      }
    });

    on<FetchCanclledorder>((event, emit) async {
      emit(OrderLoad());
      try {
        final response = await FinanceRepository()
            .fetchCancel(event.startDate, event.endDate);

        emit(OrderDone(response));
      } catch (e) {
        if (e == "204") {
          emit(NoOrder());
        } else {
          emit(OrderError());
          throw ("error");
        }
      }
    });

    on<FetchDeletedorder>((event, emit) async {
      emit(OrderLoad());
      try {
        final response = await FinanceRepository()
            .fetchDeleted(event.startDate, event.endDate);

        emit(DeletedOrderDone(response));
      } catch (e) {
        if (e == "204") {
          emit(NoOrder());
        } else {
          emit(OrderError());
          throw ("error");
        }
      }
    });

    on<FetchbyCategory>((event, emit) async {
      emit(OrderLoad());
      try {
        final response = await FinanceRepository()
            .fetchbyCat(event.startDate, event.endDate);

        emit(BycatDone(response));
      } catch (e) {
        if (e == "204") {
          emit(NoOrder());
        } else {
          emit(OrderError());
          throw ("error");
        }
      }
    });

    on<FetchbyWaiter>((event, emit) async {
      emit(OrderLoad());
      try {
        final response = await FinanceRepository()
            .fetchbywaiter(event.startDate, event.endDate);

        emit(BywaiterDone(response));
      } catch (e) {
        if (e == "204") {
          emit(NoOrder());
        } else {
          emit(OrderError());
          throw ("error");
        }
      }
    });
  }
}
