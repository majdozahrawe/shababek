import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shababeek/data/models/catagories_response.dart';
import 'package:shababeek/data/models/compliant_response.dart';
import 'package:shababeek/data/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants.dart';
import '../models/user_model.dart';
import 'api_response_handler.dart';
import 'api_result.dart';
import '../models/failure.dart';

class CompliantAPI {
  APIResult result = APIResult();

  Future<APIResult> addCompliant(String text,String token,String workerId) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Complaint/Add';

    Map<String,String> headers =
    {'Content-Type':'application/json','Authorization': "Bearer $token"};

    final msg = jsonEncode({
      'text': text,
      'workerId': workerId,

    });

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );

    CompliantResponse compliantResponse;
    var jsonResponse = jsonDecode(response.body);

    try {
      print("compliants API for Worker ID is : ");
      print(workerId);
      if (response.statusCode == 200) {
        compliantResponse = CompliantResponse.fromJson(jsonResponse);

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString(AppConstants.KEY_ACCESS_TOKEN, jsonResponse['token'].toString());
        result.hasError = false;
        result.data = compliantResponse.data;
      } else {
        print("in else");
        print(jsonResponse['error']);

        jsonResponse = jsonDecode(response.body);
        compliantResponse = CompliantResponse.fromJson(jsonResponse);
        // User user = userResponse.data;
        // MetaData responseMeta = userResponse.metaData;

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['error']);
      }

    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

    return result;
  }


}