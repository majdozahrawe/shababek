import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shababeek/data/models/worker_model.dart';
import 'dart:convert';
import 'package:shababeek/data/models/worker_response.dart';
import '../models/worker_details_model.dart';
import 'api_response_handler.dart';
import 'api_result.dart';


class WorkerAPI {


  Future<List<Worker1>> postWorkerRes(var latitude, var longitude,
      String categoryId) async {
    print("$latitude/$longitude/$categoryId");
    var url =
        'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Worker/All/$latitude/$longitude/$categoryId';
    final response = await http.get(Uri.parse(url),);

    if (response.statusCode == 200) {
      print("response : ");
      print(latitude);
      print(longitude);
      print(categoryId);
      return Worker1.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Request Failed.');
    }
  }
}
