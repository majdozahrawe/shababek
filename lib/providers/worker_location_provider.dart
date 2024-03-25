
import 'package:flutter/material.dart';
import 'package:shababeek/data/api/users_api.dart';

import '../data/api/api_result.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_model.dart';
import 'package:geolocator/geolocator.dart';

class WorkerLocationProvider with ChangeNotifier{

  bool loading = false;
  bool workerLocationIsExist = false;

  var  lat,longot;

  loadWorkerLocation(latitude,  longitude) async {
    workerLocationIsExist =false;
    lat = latitude; longot = longitude;
    workerLocationIsExist = true;
    notifyListeners();
  }

}