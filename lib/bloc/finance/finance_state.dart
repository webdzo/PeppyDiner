part of 'finance_bloc.dart';

abstract class FinanceState {}

class FinanceInitial extends FinanceState {}

class FinanceLoad extends FinanceState {}

class FinanceDone extends FinanceState {
  final FinanceModel financeList;

  FinanceDone(this.financeList);
}

class FinanceError extends FinanceState {}

class FinanceNodata extends FinanceState {}

class IncomeLoad extends FinanceState {}

class IncomeDone extends FinanceState {
  final MonthIncomeModel incomeData;

  IncomeDone(this.incomeData);
}

class IncomeError extends FinanceState {}

class IncomeNodata extends FinanceState {}

class ExpenseCatLoad extends FinanceState {}

class ExpenseCatDone extends FinanceState {
  final List<ExpenseCatModel> category;

  ExpenseCatDone(this.category);
}

class ExpenseCatError extends FinanceState {}

class ExpenseCatNodata extends FinanceState {}

class AddExpenseLoad extends FinanceState {}

class AddExpenseDone extends FinanceState {
  AddExpenseDone();
}

class AddExpenseError extends FinanceState {}

class ItemstatsLoad extends FinanceState {}

class ItemstatsDone extends FinanceState {
  final ItemstatsModel itemStats;
  ItemstatsDone(this.itemStats);
}

class ItemstatsError extends FinanceState {
  final String error;

  ItemstatsError(this.error);
}

class TimestatsLoad extends FinanceState {}

class TimestatsDone extends FinanceState {
  final List<TimestatsModel> timestats;
  TimestatsDone(this.timestats);
}

class TimestatsError extends FinanceState {}

//------------------------------------

class OrderLoad extends FinanceState {}

class OrderError extends FinanceState {}

class NoOrder extends FinanceState {}

class OrderDone extends FinanceState {
  final List<CancelOrderModel> orders;

  OrderDone(this.orders);
}

class DeletedOrderDone extends FinanceState {
  final List<DeleteditemModel> orders;

  DeletedOrderDone(this.orders);
}

class BycatDone extends FinanceState {
  final List<BycatModel> orders;

  BycatDone(this.orders);
}

class BywaiterDone extends FinanceState {
  final List<BywaiterModel> orders;

  BywaiterDone(this.orders);
}

class HistoryDone extends FinanceState {
  final List<ItemhistoryModel> orders;

  HistoryDone(this.orders);
}

class SalepaymentDone extends FinanceState {
  final List<SalepaymentModel> orders;

  SalepaymentDone(this.orders);
}
