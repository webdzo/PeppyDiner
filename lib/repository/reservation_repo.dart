import 'dart:convert';

import '../models/reservation_details_model.dart';
import '../resources/api_base_helper.dart';

class ReservationsRepository {
/*   Future<List<ReservationsModel>> data() async {
    var response =
        await ApiBaseHelper().getMethod("/reservations/today?date=2023-07-28");

    List<ReservationsModel> rserv = List.from(
        json.decode(response.body).map((e) => ReservationsModel.fromJson(e)));

    return rserv;
  } */

  Future<ReservationsDetailsModel> details(int id) async {
    var response = await ApiBaseHelper().getMethod("/reservations/$id");

    ReservationsDetailsModel categoryResponse =
        ReservationsDetailsModel.fromJson(json.decode(response.body));

    return categoryResponse;
  }
}
