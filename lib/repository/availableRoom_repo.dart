import 'dart:convert';
import 'dart:core';

import '../models/availableTables_model.dart';
import '../resources/api_base_helper.dart';

class AvailableRoomRepository {
  Future<AvailableTablesModel> data(String startDate, String endDate) async {
    var response = await ApiBaseHelper()
        .getMethod("/reservations/availability?date=$startDate&time=$endDate");
    
    AvailableTablesModel apiresponse =
        AvailableTablesModel.fromJson(json.decode(response.body));

    return apiresponse;
  }
}
