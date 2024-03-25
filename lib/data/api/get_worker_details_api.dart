
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shababeek/data/models/worker_model.dart';
import 'dart:convert';
import 'package:shababeek/data/models/worker_response.dart';
import '../models/worker_details_model.dart';
import 'api_response_handler.dart';
import 'api_result.dart';



class WorkerDetailsAPI {

  Future<WorkerDetailsModel> postWorkerID(String workerID) async {
    var url =
        'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Worker/Details/$workerID';
    Map<String,String> headers = {'Content-Type':'application/json'};
    final msg = jsonEncode({
      'userId': workerID,
    });

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );
    if (response.statusCode == 200) {
      print(response.body);

      return WorkerDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Request Failed.');
    }
  }

}
