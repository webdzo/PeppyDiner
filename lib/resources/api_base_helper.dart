import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main_qa.dart';

//Webdzo Stayz

//String qa = "https://stayz.webdzo.com/api";

class ApiBaseHelper {
  Future<http.Response> postMethod(String url, String request,
      {bool isMultipart = false}) async {
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";

    var response = await http.post(
      Uri.parse("${BaseUrl.appBaseurl}$url"),
      headers: {
        "x-access-token": token,
        /*   "Access-Control-Allow-Origin":
              "http://qa-webdzo-stayz.s3-website.ap-south-1.amazonaws.com", */
        "Content-Type": isMultipart
            ? 'application/x-www-form-urlencoded'
            : 'application/json'
      },
      body: isMultipart ? {"data": request} : request,
    );

    handleResponse(response);
    return response;
  }

  Future<http.Response> putMethod(
    String url,
    String request,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
   
    var response = await http.put(
      Uri.parse("${BaseUrl.appBaseurl}$url"),
      headers: {"x-access-token": token, "Content-Type": 'application/json'},
      body: request,
    );

    handleResponse(response);
    return response;
  }

  Future<http.Response> deleteMethod(
    String url,
    String request,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    var response = await http.delete(
      Uri.parse("${BaseUrl.appBaseurl}$url"),
      headers: {"x-access-token": token, "Content-Type": 'application/json'},
      body: request,
    );

    handleResponse(response);
    return response;
  }

  void handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      logError(response.request.toString(), response.body);

      if (response.statusCode == 204) {
        throw response.statusCode.toString();
      } else {
        log(json.decode(response.body)["message"]);
        throw json.decode(response.body)["message"];
      }
    } else {
      logSuccess(response.request.toString(), response.body);
    }
  }

  Future<http.Response> getMethod(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    var response = await http.get(Uri.parse("${BaseUrl.appBaseurl}$url"),
        headers: {'x-access-token': token});
    handleResponse(response);
    return response;
  }

  void logSuccess(String logName, dynamic msg) {
    log('\x1B[32m$logName $msg\x1B[0m');
  }

  void logError(String logName, dynamic msg) {
    log('\x1B[31m$logName $msg\x1B[0m');
  }
}
