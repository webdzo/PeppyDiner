import 'dart:convert';
import 'dart:core';

import 'package:hotelpro_mobile/bloc/finance/finance_bloc.dart';
import 'package:hotelpro_mobile/models/bycat_model.dart';
import 'package:hotelpro_mobile/models/bywaiter_model.dart';
import 'package:hotelpro_mobile/models/cancelorder_model.dart';
import 'package:hotelpro_mobile/models/deleted_item_model.dart';
import 'package:hotelpro_mobile/models/itemstats_model.dart';
import 'package:hotelpro_mobile/models/timestats_model.dart';
import 'package:http/http.dart';

import '../models/add_exp_request.dart';
import '../models/finance_model.dart';
import '../models/monthincome_model.dart';
import '../resources/api_base_helper.dart';

class FinanceRepository {
  Future<FinanceModel> data() async {
    var response = await ApiBaseHelper().getMethod("/income-expense");

    FinanceModel financeResponse =
        FinanceModel.fromJson(jsonDecode(response.body));

    return financeResponse;
  }

  Future<MonthIncomeModel> incomeData() async {
    var response = await ApiBaseHelper().getMethod("/reports/prev-curr-months");

    MonthIncomeModel incomeResponse =
        MonthIncomeModel.fromJson(jsonDecode(response.body));

    return incomeResponse;
  }

  /*  Future<List<ExpenseCatModel>> getExpenseCat() async {
    var response =
        await ApiBaseHelper().getMethod("/income-expense/expense-categories");

    List<ExpenseCatModel> incomeResponse = List.from(json.decode(response.body))
        .map((e) => ExpenseCatModel.fromJson(e))
        .toList();

    return incomeResponse;
  } */

  Future<Response> addExpense(AddExpenseRequest request) async {
    var response = await ApiBaseHelper().postMethod(
      "/income-expense/add-income-expense",
      jsonEncode(request.toJson()),
    );
    return response;
  }

  Future<ItemstatsModel> getItemstats(String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reports/item-stats-by-date?startDate=$startDate&endDate=$endDate");

    ItemstatsModel statResponse =
        ItemstatsModel.fromJson(jsonDecode(response.body));

    return statResponse;
  }

  Future<List<TimestatsModel>> getTimestats(
      String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reports/sales?type=&startDate=$startDate&endDate=$endDate");

    List<TimestatsModel> statResponse = List.from(json.decode(response.body))
        .map((e) => TimestatsModel.fromJson(e))
        .toList();

    return statResponse;
  }

  Future<List<CancelOrderModel>> fetchCancel(
      String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reports/multiple?category=cancelledorders&startDate=$startDate&endDate=$endDate");

    List<CancelOrderModel> statResponse =
        List.from(json.decode(response.body)["query_data"]) //
            .map((e) => CancelOrderModel.fromJson(e))
            .toList();

    return statResponse;
  }

  Future<List<DeleteditemModel>> fetchDeleted(
      String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reports/multiple?category=deleteditems&startDate=$startDate&endDate=$endDate");

    List<DeleteditemModel> statResponse =
        List.from(json.decode(response.body)["query_data"]) //
            .map((e) => DeleteditemModel.fromJson(e))
            .toList();

    return statResponse;
  }

  Future<List<BycatModel>> fetchbyCat(String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reports/multiple?category=ordersbycategory&startDate=$startDate&endDate=$endDate");

    List<BycatModel> statResponse =
        List.from(json.decode(response.body)["query_data"]) //
            .map((e) => BycatModel.fromJson(e))
            .toList();

    return statResponse;
  }

  Future<List<BywaiterModel>> fetchbywaiter(
      String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reports/multiple?category=ordersbywaiter&startDate=$startDate&endDate=$endDate");

    List<BywaiterModel> statResponse =
        List.from(json.decode(response.body)["query_data"]) //
            .map((e) => BywaiterModel.fromJson(e))
            .toList();

    return statResponse;
  }
}
