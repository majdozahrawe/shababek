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

class ChangePasswordAPI {
  APIResult result = APIResult();

  Future<APIResult> changePasswordRequest(String userId, String newPassword) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Password/Change';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final msg = jsonEncode({
      'userId': userId,
      'newPassword': newPassword,
    });
    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );
    UserResponse userResponse;
    var jsonResponse = jsonDecode(response.body);

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