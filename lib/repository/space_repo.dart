import 'dart:convert';

import '../models/space_model.dart';
import '../resources/api_base_helper.dart';

class SpaceRepository {
  Future<List<SpaceModel>> data() async {
    var response = await ApiBaseHelper().getMethod("/tables/space-categories");

    List<SpaceModel> spaceResponse = List.from(
        json.decode(response.body).map((e) => SpaceModel.fromJson(e)));

    return spaceResponse;
  }
}
