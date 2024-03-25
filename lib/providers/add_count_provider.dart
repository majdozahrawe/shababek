import 'package:flutter/material.dart';
import 'package:shababeek/data/api/add_count_api.dart';
import 'package:shababeek/data/models/add_count_model.dart';


enum AddCountState{initial, loading, loaded, error}
class AddCountProvider with ChangeNotifier{
  AddCountState state = AddCountState.initial;

  late AddCountModel addCountModel;

  AddOneCount(String workerId, bool isPhoneCall) async {
    addCountModel = await AddCountAPI().AddCallCount(workerId, isPhoneCall);
    state = AddCountState.loaded;
    notifyListeners();
  }
}