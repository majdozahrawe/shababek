
import 'package:flutter/material.dart';

import '../data/api/api_result.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_details_model.dart';
import '../data/models/worker_model.dart';



enum WorkerState{initial, loading, loaded, error}
class WorkerProvider with ChangeNotifier {
  WorkerState state = WorkerState.initial;


  late List <Worker1> listWorkers;
  bool loading = false;

  loadWorker(latitude, longitude, categoryId) async {
    state = WorkerState.loading;
    listWorkers = await WorkerAPI().postWorkerRes(latitude, longitude, categoryId);
    state = WorkerState.loaded;
    notifyListeners();
    return listWorkers;
  }


}