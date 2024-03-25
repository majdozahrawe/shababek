
import 'package:flutter/material.dart';
import 'package:shababeek/data/api/users_api.dart';

import '../data/api/api_result.dart';
import '../data/api/get_worker_details_api.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_details_model.dart';
import '../data/models/worker_model.dart';

enum WorkerDetailsState { initial, loaded, error }

class WorkerProfileProvider with ChangeNotifier{
  WorkerDetailsState state = WorkerDetailsState.initial;

  late WorkerDetailsModel workerDetails;

  loadWorkerDetails(String workerID) async {
    setState(WorkerDetailsState.initial);

    workerDetails = await WorkerDetailsAPI().postWorkerID(workerID);
    setState(WorkerDetailsState.loaded);
  }

  setState(state) {
    this.state = state;
    notifyListeners();
  }
}