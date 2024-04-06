import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shababeek/data/models/catagories_response.dart';
import 'package:shababeek/data/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants.dart';
import '../models/user_model.dart';
import 'api_response_handler.dart';
import 'api_result.dart';
import '../models/failure.dart';

class UsersAPI {
  APIResult result = APIResult();

  Future<APIResult> login(String phone, String password) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/User/Login';

    Map<String,String> headers = {'Content-Type':'application/json'};
    final msg = jsonEncode({
      'phone': phone,
      'password': password
    });

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );

    UserResponse userResponse;
    var jsonResponse = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {

        print("Login Success");
        print(jsonResponse['token'].toString());

        userResponse = UserResponse.fromJson(jsonResponse);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AppConstants.KEY_ACCESS_TOKEN, jsonResponse['token'].toString());



        result.hasError = false;
        result.data = userResponse.data;
      } else {
        print("in else");
        print(jsonResponse['message']);

        jsonResponse = jsonDecode(response.body);
        userResponse = UserResponse.fromJson(jsonResponse);
        // User user = userResponse.data;
        // MetaData responseMeta = userResponse.metaData;

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['message']);
      }

    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

    return result;
  }
  Future<APIResult> delete(String phone, String password) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/User/Delete';

    Map<String,String> headers = {'Content-Type':'application/json'};
    final msg = jsonEncode({
      'phone': phone,
      'password': password
    });

    final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: msg
    );

    UserResponse userResponse;
    var jsonResponse = jsonDecode(response.body);

    print(response.body);

    try {
      if (response.statusCode == 200) {

        print("Delete success");
        print(jsonResponse['token'].toString());

        userResponse = UserResponse.fromJson(jsonResponse);

        result.hasError = false;
        result.data = userResponse.data;
      } else {
        print("in else");
        print(jsonResponse['message']);

        jsonResponse = jsonDecode(response.body);
        userResponse = UserResponse.fromJson(jsonResponse);
        // User user = userResponse.data;
        // MetaData responseMeta = userResponse.metaData;

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['message']);
      }

    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

    return result;
  }

  Future<APIResult> register(String firstName,String lastName,String phone,String password) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/User/Signup';


    Map<String,String> headers = {'Content-Type':'application/json'};
    final msg = jsonEncode({
      'firstName' : firstName,
      'lastName' : lastName,
      'phone': phone,
      'password': password,
    });

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );

    UserResponse userResponse;
    var jsonResponse = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {

        print("register Success");
        print(jsonResponse['token'].toString());

        userResponse = UserResponse.fromJson(jsonResponse);

        result.hasError = false;
        result.data = userResponse.data;
      } else {
        jsonResponse = jsonDecode(response.body);
        userResponse = UserResponse.fromJson(jsonResponse);
        // MetaData responseMeta = userResponse.metaData;

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['message']);
      }
    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

    return result;
  }

  Future<APIResult> getUserByToken(String token) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/User/Details';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer "+token},
    );
    UserResponse userResponse;
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("Token : $token");
      userResponse = UserResponse.fromJson(jsonResponse);
      result.hasError = false;
      result.data = userResponse.data;
    } else {
      jsonResponse = jsonDecode(response.body);
      userResponse = UserResponse.fromJson(jsonResponse);
      // MetaData responseMeta = userResponse.metaData;

      result.hasError = true;
    }
    return result;
  }

  Future<APIResult> updateUserProfile(String token,String firstName,String lastName,String phone) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/User/Update';

    Map<String,String> headers = {'Content-Type':'application/json','Authorization': "Bearer $token"};
    final msg = jsonEncode({
      'firstName' : firstName,
      'lastName' : lastName,
      'phone': phone,
    });
    final response = await http.patch(
        Uri.parse(url),
        headers:headers,
        body: msg
    );
    UserResponse userResponse;
    var jsonResponse = jsonDecode(response.body);

    print(token);

    if (response.statusCode == 200) {
      userResponse = UserResponse.fromJson(jsonResponse);
      result.hasError = false;
      result.data = userResponse.data;
    } else {
      jsonResponse = jsonDecode(response.body);
      userResponse = UserResponse.fromJson(jsonResponse);

      result.hasError = true;
    }
    return result;
  }




}