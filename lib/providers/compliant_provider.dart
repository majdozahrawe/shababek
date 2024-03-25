import 'package:flutter/material.dart';
import 'package:shababeek/data/api/compliant_api.dart';
import 'package:shababeek/data/api/users_api.dart';
import 'package:shababeek/data/models/compliant_model.dart';

import '../data/api/api_result.dart';
import '../data/models/user_model.dart';


enum CompliantState{initial, loading, loaded, error}
class CompliantProvider with ChangeNotifier{

  CompliantState state = CompliantState.initial;
  late CompliantModel compliantModel;
  late APIResult apiResult;
  late String errorMessage;


  sendCompliant(text,token,workerId)async{
    print(text);
    setState(CompliantState.loading);
    apiResult = await CompliantAPI().addCompliant(text,token,workerId);
    if(!apiResult.hasError){
      compliantModel = apiResult.data;
      setState(CompliantState.loaded);

    }else{
      setState(CompliantState.error);
    }
  }

  setState(state){
    this.state = state;
    notifyListeners();
  }

}