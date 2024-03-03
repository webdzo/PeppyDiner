import 'dart:convert';
import 'dart:core';

import 'package:intl/intl.dart';

import '../models/availableTables_model.dart';
import '../resources/api_base_helper.dart';

class AvailableRoomRepository {
  Future<AvailableTablesModel> data(String startDate, String endDate) async {
    var response = await ApiBaseHelper().getMethod(
        "/reservations/tables/available?startTime=${"${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z"}");

    AvailableTablesModel apiresponse =
        AvailableTablesModel.fromJson(json.decode(response.body));

    return apiresponse;
  }

  Future<List<TablesList>> fetch() async {
    var response = await ApiBaseHelper().getMethod(
        "/reservations/tables/available?startTime=${"${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z"}");

    List<TablesList> res = List.from(json
        .decode(response.body)["tablesList"]
        .map((e) => TablesList.fromJson(e)));

    return res;
  }
}
