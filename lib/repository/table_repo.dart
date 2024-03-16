import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:hotelpro_mobile/models/availableTables_model.dart';
import 'package:hotelpro_mobile/models/edittable_request.dart';
import 'package:hotelpro_mobile/models/leveltable_model.dart';
import 'package:hotelpro_mobile/models/space_model.dart';
import 'package:hotelpro_mobile/models/table_model.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/api_base_helper.dart';

class TablesRepository {
  Future<List<TableModel>> data(
      {String type = "", bool nonDiner = false}) async {
    var response = await ApiBaseHelper().getMethod(nonDiner
        ? "/reservations/non-dining/$type"
        : (type == "past" || type == "upcoming")
            ? "/reservations/$type"
            : "/reservations/current?dining_type=dining");

    List<TableModel> tableResponse = List.from(
        json.decode(response.body).map((e) => TableModel.fromJson(e)));

    return tableResponse;
  }

  Future<Response> assign(String id, List<int> tableId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String waiterId = pref.getString("userId") ?? "";
    var response = await ApiBaseHelper().putMethod(
        "/reservations/$id/assign-waiter/$waiterId",
        json.encode({"tables_ids": tableId}));

    return response;
  }

  Future<Response> close(String id,
      {bool close = false,
      bool open = false,
      bool nonDiner = false,
      int nonDiveResrvid = 0}) async {
    var response = await ApiBaseHelper().putMethod(
        (nonDiner && close)
            ? "/orders/$id/close"
            : (nonDiner && !close && !open)
                ? "/orders/$id/complete"
                : "/reservations/$id/status/${open ? "OP" : close ? "CN" : "CO"}",
        (nonDiner && !close && !open)
            ? json.encode({
                "reservation_id": nonDiveResrvid,
                "current_time":
                    "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z"
              })
            : json.encode({
                "current_time":
                    "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z"
              }));

    return response;
  }

  Future<Response> printKot(int id, int waiterId, {bool kot = true}) async {
    var response = await ApiBaseHelper().getMethod(
        kot ? "/reservations/$id/print-kot" : "/reservations/$id/print-bill");
// "/reservations/$id/print-kot?waiter_id=$waiterId"

    return response;
  }

  ///reservations/:id/print-kot
  Future<LeveltableModel> getLeveltables(String time, int levelId) async {
    var response = await ApiBaseHelper().getMethod(
        "/tables/reserved?time=${"${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z"}&spaceId=$levelId");

    LeveltableModel res = LeveltableModel.fromJson(json.decode(response.body));

    return res;
  }

  Future<List<SpaceModel>> getSpaces() async {
    var response = await ApiBaseHelper().getMethod("/tables/space-categories");

    List<SpaceModel> res = List.from(
        json.decode(response.body).map((e) => SpaceModel.fromJson(e)));

    return res;
  }

  Future<List<TablesList>> getTables() async {
    var response = await ApiBaseHelper().getMethod("/tables");

    List<TablesList> res = List.from(
        json.decode(response.body).map((e) => TablesList.fromJson(e)));

    return res;
  }

  Future<Response> create(EdittableRequest req, {int? id}) async {
    log(jsonEncode(req.toJson()).toString());
    if (id != null) {
      var response = await ApiBaseHelper()
          .putMethod("/tables/$id", jsonEncode({"data": req.toJson()}));
      return response;
    } else {
      var response = await ApiBaseHelper()
          .postMethod("/tables", jsonEncode({"data": req.toJson()}));
      return response;
    }
  }

  Future<Response> delete(int id) async {
    var response =
        await ApiBaseHelper().deleteMethod("/tables/$id", json.encode({}));

    return response;
  }
}
