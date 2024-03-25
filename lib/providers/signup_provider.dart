import 'package:flutter/material.dart';
import 'package:shababeek/data/api/users_api.dart';

import '../data/api/api_result.dart';
import '../data/models/user_model.dart';


enum SignUpScreenState{initial, loading, loaded, error}
class SignUpProvider with ChangeNotifier{

  SignUpScreenState state = SignUpScreenState.initial;
  late User user;
  late APIResult apiResult;
  late String errorMessage;

  register(firstName, lastName,phone,password)async{
    setState(SignUpScreenState.loading);
    apiResult = await UsersAPI().register(firstName, lastName, phone, password);

    if(!apiResult.hasError){
      user = apiResult.data;
      setState( SignUpScreenState.loaded);

    }else{
      errorMessage = apiResult.failure.message;
      setState(SignUpScreenState.error);
    }
  }

  setState(state){
    this.state = state;
    notifyListeners();
  }

}