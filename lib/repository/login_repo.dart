import 'dart:convert';
import 'dart:core';

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../resources/api_base_helper.dart';

class LoginRepository {
  Future<LoginResponse> data(LoginRequest request) async {
   
    var response = await ApiBaseHelper().postMethod(
      "/auth/signin",
      json.encode(request),
    );

   

    return LoginResponse.fromJson(json.decode(response.body));
  }
}
