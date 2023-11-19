import 'dart:convert';
import 'dart:core';

import 'package:hotelpro_mobile/models/orderlist_model.dart';
import 'package:http/http.dart';

import '../models/addOrders_request.dart';
import '../models/additem_model.dart';
import '../models/username_model.dart';
import '../resources/api_base_helper.dart';

class OrdersRepository {
  /*  Future<DetailsModel> data(String id) async {
    var response = await ApiBaseHelper().getMethod("/reservations/$id");
    print(response.body);

    DetailsModel ordersResponse =
        DetailsModel.fromJson(json.decode(response.body));

    return ordersResponse;
  } */

  Future<List<OrderlistModel>> data(String id, String tableId) async {
    var response = await ApiBaseHelper()
        .getMethod("/tables/$tableId/orders?reservation_id=$id");
   

    List<OrderlistModel> ordersResponse = List.from(json
        .decode(response.body)["orders"]
        .map((e) => OrderlistModel.fromJson(e)));

    return ordersResponse;
  }

  Future<Response> addOrders(AddOrdersRequest request) async {
   
    var response = await ApiBaseHelper().postMethod(
      "/orders",
      jsonEncode(request.toJson()),
    );

    return response;
  }

  Future<Response> addItems(AddItemsRequest request, String id) async {
   
    var response = await ApiBaseHelper().putMethod(
      "/orders/$id",
      jsonEncode(request.toJson()),
    );

    return response;
  }

  Future<Response> editOrders(
      String orderId, String itemId, String qty, String notes) async {
    var response = await ApiBaseHelper().putMethod(
      "/orders/$orderId/items/$itemId",
      jsonEncode({"item_quantity": qty, "notes": notes}),
    );

    return response;
  }

  Future<Response> deleteItem(String orderId, String itemId) async {
    var response = await ApiBaseHelper().deleteMethod(
      "/orders/$orderId/items/$itemId",
      jsonEncode({}),
    );

    return response;
  }

  Future<Response> deleteOrder(String orderId) async {
    var response = await ApiBaseHelper().deleteMethod(
      "/orders/$orderId",
      jsonEncode({}),
    );

    return response;
  }

  Future<List<UsernameModel>> getName(String id) async {
    var response = await ApiBaseHelper().getMethod("/users/all");
  

    List<UsernameModel> userResponse = List.from(
        json.decode(response.body).map((e) => UsernameModel.fromJson(e)));

    return userResponse;
  }
}
