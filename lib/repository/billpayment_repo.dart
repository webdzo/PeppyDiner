import 'dart:convert';

import 'package:hotelpro_mobile/models/billpayment_model.dart';
import 'package:hotelpro_mobile/models/billupdate_request.dart';
import 'package:hotelpro_mobile/models/discount_model.dart';
import 'package:hotelpro_mobile/models/payments_model.dart';
import 'package:hotelpro_mobile/models/servicecharge_model.dart';
import 'package:hotelpro_mobile/resources/api_base_helper.dart';
import 'package:http/http.dart';

class BillRepo {
  Future<List<ServicechargeModel>> charges() async {
    var response = await ApiBaseHelper().getMethod("/service-charges");

    List<ServicechargeModel> maincategoryResponse = List.from(
        json.decode(response.body).map((e) => ServicechargeModel.fromJson(e)));

    return maincategoryResponse;
  }

  Future<List<DiscountModel>> discounts() async {
    var response = await ApiBaseHelper().getMethod("/discounts");

    List<DiscountModel> maincategoryResponse = List.from(
        json.decode(response.body).map((e) => DiscountModel.fromJson(e)));

    return maincategoryResponse;
  }

  Future<List<PaymentsModel>> payments() async {
    var response =
        await ApiBaseHelper().getMethod("/reservations/payment-modes");

    List<PaymentsModel> maincategoryResponse = List.from(
        json.decode(response.body).map((e) => PaymentsModel.fromJson(e)));

    return maincategoryResponse;
  }

  Future<BillpaymentModel> billDetail(String id) async {
    var response =
        await ApiBaseHelper().getMethod("/reservations/$id/bill-summary");

    BillpaymentModel maincategoryResponse =
        BillpaymentModel.fromJson(json.decode(response.body));

    return maincategoryResponse;
  }

  Future<Response> update(BillupdateRequest request,String id) async {
    var response = await ApiBaseHelper()
        .putMethod("/reservations/$id/bill-summary", json.encode(request));

    return response;
  }
}
