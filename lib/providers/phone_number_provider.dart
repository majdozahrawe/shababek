
import 'package:flutter/material.dart';

import '../data/api/api_result.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_details_model.dart';
import '../data/models/worker_model.dart';



enum PhoneNumberState{initial, loading, loaded, error}
class PhoneNumberProvider with ChangeNotifier {
  late String  phone_number;
  setPhoneNumber(phone) async {
    phone_number = phone;
    notifyListeners();
  }

}