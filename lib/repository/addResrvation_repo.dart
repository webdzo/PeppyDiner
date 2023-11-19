import 'dart:convert';
import 'dart:core';

import 'package:hotelpro_mobile/models/occasion_model.dart';
import 'package:http/http.dart';

import '../models/addReserv_request.dart';
import '../models/cakes_model.dart';
import '../models/packages_model.dart';
import '../models/reservation_details_model.dart' as details;
import '../resources/api_base_helper.dart';

class AddReservationRepository {
  Future<Response> data(AddReservRequest request,
      {bool edit = false,
      bool addGuest = false,
      String id = "",
      String guestId = ""}) async {
  
    /*  if (edit) {
      var response = await ApiBaseHelper().putMethod(
          "/guests/$guestId",
          jsonEncode({
            "reservation_id": int.parse(id),
            "data": {
              "firstname": request.guestfirstname,
              "lastname": request.guestlastname,
              "email": request.guestemail,
              "phone": request.guestphone,
              "dob": request.guestdob ?? "",
              "gender": request.guestgender?.toString()
            }
          }));
      return response;
    } else */
    /*    if (addGuest) {
      var response = await ApiBaseHelper().postMethod(
          "/guests",
          jsonEncode({
            "reservation_id": int.parse(id),
            "data": {
              "firstname": request.guestfirstname,
              "lastname": request.guestlastname,
              "email": request.guestemail,
              "phone": request.guestphone,
              "dob": request.guestdob ?? "",
              "gender": request.guestgender?.toString()
            }
          }));
      return response;
    } else { */
    var response = await ApiBaseHelper().postMethod(
      "/reservations",
      //isMultipart: true,
      jsonEncode(request.toJson()),
    );
    return response;
    //}
  }

  Future<Response> updateGuest(Map<String, String> request, int id) async {
    var response = await ApiBaseHelper().putMethod(
      "/reservations/$id/guests",
      jsonEncode({"data": request}),
    );

    return response;
  }

  Future<Response> updateData(AddReservRequest request, int id) async {
   
    var response = await ApiBaseHelper().putMethod(
      "/reservations/$id/tables",
      jsonEncode({
        "selected_tables":
            request.selectedTables?.map((e) => e.toJson()).toList(),
      }),
    );

    return response;
  }

  Future<Response> action(int id, int statusId) async {
    var response = await ApiBaseHelper().putMethod(
      statusId == 1
          ? "/reservations/$id/close/1"
          : statusId == 3
              ? "/reservations/$id/close/3"
              : statusId == 2
                  ? "/reservations/$id/close/2"
                  : "/reservations/$id/open",
      jsonEncode({}),
    );

    return response;
  }

  Future<Response> paynow(String id, String amount) async {
    var response = await ApiBaseHelper().putMethod(
      "/reservations/$id/pay-amount",
      jsonEncode({"amount": amount}),
    );

    return response;
  }

  Future<Response> resendMail(String id) async {
    var response = await ApiBaseHelper().postMethod(
      "/reservations/send-email/$id",
      isMultipart: false,
      jsonEncode({}),
    );

    return response;
  }

  Future<Response> editDiscount(String id, String discount) async {
    var response = await ApiBaseHelper().putMethod(
      "/reservations/$id/discount",
      jsonEncode({"discount": discount}),
    );

    return response;
  }

  Future<Response> editCount(String id, dynamic count) async {
    var response = await ApiBaseHelper().putMethod(
      "/reservations/$id/guest-count",
      jsonEncode(count.toJson()),
    );

    return response;
  }

  Future<Response> deleteRoom(String id, details.TablesSelected table) async {
    var response = await ApiBaseHelper().deleteMethod(
      "/reservations/$id/tables",
      jsonEncode({"tables": table.toJson()}),
    );

    return response;
  }

  Future<List<OccasionsModel>> getOccasions() async {
    var response = await ApiBaseHelper().getMethod("/occasions");

    List<OccasionsModel> occasionResponse = List.from(
        json.decode(response.body).map((e) => OccasionsModel.fromJson(e)));

    return occasionResponse;
  }

  Future<List<PackagesModel>> getPackages() async {
    var response = await ApiBaseHelper().getMethod("/packages");

    List<PackagesModel> packagesResponse = List.from(
        json.decode(response.body).map((e) => PackagesModel.fromJson(e)));

    return packagesResponse;
  }

  Future<List<CakesModel>> getCakes() async {
    var response = await ApiBaseHelper().getMethod("/cake");

    List<CakesModel> packagesResponse = List.from(
        json.decode(response.body).map((e) => CakesModel.fromJson(e)));

    return packagesResponse;
  }
}
