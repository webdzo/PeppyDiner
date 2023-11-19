import 'package:flutter_bloc/flutter_bloc.dart';

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

    /*  on<FetchExpenseCat>((event, emit) async {
      emit(ExpenseCatLoad());
      try {
        final response = await FinanceRepository().getExpenseCat();

        emit(ExpenseCatDone(response));
      } catch (e) {
        if (e == "204") {
          emit(ExpenseCatNodata());
        } else {
          emit(ExpenseCatError());
          throw ("error");
        }
      }
    }); */

    on<AddExpenseEvent>((event, emit) async {
      emit(AddExpenseLoad());
      try {
        final response = await FinanceRepository().addExpense(event.request);

        emit(AddExpenseDone());
      } catch (e) {
        emit(AddExpenseError());
        throw ("error");
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
          emit(ItemstatsError());
        } else {
          emit(ItemstatsError());
          throw ("error");
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
  }
}
