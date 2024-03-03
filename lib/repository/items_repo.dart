import 'dart:convert';
import 'dart:core';

import 'package:hotelpro_mobile/models/editItemconfig_request.dart';
import 'package:hotelpro_mobile/models/itemconfig_model.dart';
import 'package:http/http.dart';

import '../models/items_model.dart';
import '../resources/api_base_helper.dart';

class ItemsRepository {
  Future<List<ItemsModel>> data(String id) async {
    var response = await ApiBaseHelper()
        .getMethod(id == "All" ? "/items" : "/items/categories/$id");
    print(response.body);
    List<ItemsModel> itemsResponse = List.from(
        json.decode(response.body).map((e) => ItemsModel.fromJson(e)));

    return itemsResponse;
  }

  Future<List<ItemConfigModel>> items() async {
    var response = await ApiBaseHelper().getMethod("/items");

    List<ItemConfigModel> maincategoryResponse = List.from(
        json.decode(response.body).map((e) => ItemConfigModel.fromJson(e)));

    return maincategoryResponse;
  }

  Future<Response> enable(bool enable, List<int> ids) async {
    var response = await ApiBaseHelper().putMethod(
        "/items/enable", json.encode({"enabled": enable, "item_ids": ids}));
    return response;
  }

  Future<Response> edit(EditItemconfigRequest request, int id) async {
    var response = await ApiBaseHelper()
        .putMethod("/items/$id", json.encode({"data": request.toJson()}));
    return response;
  }

  Future<Response> delete(int id) async {
    var response =
        await ApiBaseHelper().deleteMethod("/items/$id", jsonEncode({}));
    return response;
  }
}
