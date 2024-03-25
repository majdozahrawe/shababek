import 'dart:convert';

import 'package:shababeek/data/models/add_count_response.dart';
import 'package:shababeek/data/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants.dart';
import '../models/add_count_model.dart';
import '../models/user_model.dart';
import 'api_response_handler.dart';
import 'api_result.dart';
import '../models/failure.dart';
import 'package:http/http.dart' as http;

class AddCountAPI {
  APIResult result = APIResult();

  Future<AddCountModel> AddCallCount(String workerId, bool isPhoneCall) async {
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/WorkerReport/Add';

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      'workerId': workerId,
      'isPhoneCall': isPhoneCall
    });

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );

    AddCountResponse addCountResponse;
    var jsonResponse = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print("click added");
        addCountResponse = AddCountResponse.fromJson(jsonResponse);

        result.hasError = false;
        result.data = addCountResponse.data;
      } else {
        jsonResponse = jsonDecode(response.body);
        addCountResponse = AddCountResponse.fromJson(jsonResponse);

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['message']);
      }
    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

    return result.data;
  }

}