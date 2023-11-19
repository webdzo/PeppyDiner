part of 'finance_bloc.dart';

abstract class FinanceEvent {}

class FetchFinance extends FinanceEvent {
  FetchFinance();
}

class FetchIncome extends FinanceEvent {
  FetchIncome();
}

class FetchExpenseCat extends FinanceEvent {
  FetchExpenseCat();
}

class AddExpenseEvent extends FinanceEvent {
  final AddExpenseRequest request;
  AddExpenseEvent(this.request);
}

class FetchItemstats extends FinanceEvent {
  final String startDate;
  final String endDate;
  FetchItemstats(this.startDate, this.endDate);
}

class FetchTimestats extends FinanceEvent {
  final String startDate;
  final String endDate;
  FetchTimestats(this.startDate, this.endDate);
}
