import 'dart:convert';
import 'dart:core';



import '../models/category_model.dart';
import '../models/main_category_model.dart';
import '../resources/api_base_helper.dart';

class CategoryRepository {
  Future<List<CategoryModel>> data(int id, {bool all = false}) async {
    var response = await ApiBaseHelper().getMethod(all
        ? "/items/categories/subcategories"
        : "/items/categories/$id/subcategories");

    List<CategoryModel> categoryResponse = List.from(
        json.decode(response.body).map((e) => CategoryModel.fromJson(e)));

    return categoryResponse;
  }

  Future<List<MainCategoryModel>> category() async {
    var response = await ApiBaseHelper().getMethod("/items/categories/parent");

    List<MainCategoryModel> maincategoryResponse = List.from(
        json.decode(response.body).map((e) => MainCategoryModel.fromJson(e)));

    return maincategoryResponse;
  }


}
