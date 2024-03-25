
import 'package:flutter/material.dart';

import '../data/api/api_result.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_details_model.dart';
import '../data/models/worker_model.dart';



enum RegisterInfoState{initial, loading, loaded, error}
class RegisterInfoProvider with ChangeNotifier {
  late String r_firstName, r_lastName, r_phone, r_password;

  setRegInfo(firstName,lastName,phone,password) async {
    r_firstName = firstName;
    r_lastName = lastName;
    r_phone = phone;
    r_password = password;
    notifyListeners();
  }

}