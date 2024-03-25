
import 'package:flutter/material.dart';
import 'package:shababeek/data/api/users_api.dart';

import '../data/api/api_result.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_model.dart';
import 'package:geolocator/geolocator.dart';

enum LatLonState{initial, loading, loaded, error}
class LatLonProvider with ChangeNotifier{

  bool loading = false;
  bool locationIsExist = false;

  var  lat,longot;

  loadLocation( latitude,  longitude) async {
    locationIsExist = false;
    lat = latitude; longot = longitude;
    locationIsExist = true;
    notifyListeners();
  }
}