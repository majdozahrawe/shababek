import 'package:flutter/material.dart';
import 'package:shababeek/data/api/users_api.dart';

import '../data/api/api_result.dart';
import '../data/models/user_model.dart';

enum AuthState { initial, loading, loaded, error }

class AuthProvider with ChangeNotifier {
  AuthState state = AuthState.initial;
  late User user;
  late APIResult apiResult;
  late String errorMessage;

  login(phone, password) async {
    setState(AuthState.loading);
    apiResult = await UsersAPI().login(phone, password);

    if (!apiResult.hasError) {
      user = apiResult.data;
      setState(AuthState.loaded);
    } else {
      errorMessage = apiResult.failure.message;
      setState(AuthState.error);
    }
  }
  delete(phone, password) async {
    setState(AuthState.loading);
    apiResult = await UsersAPI().delete(phone, password);

    if (!apiResult.hasError) {
      print("delete email is done in provider");
      user = apiResult.data;
      setState(AuthState.loaded);
    } else {
      errorMessage = apiResult.failure.message;
      setState(AuthState.error);
    }
  }

  loadUser(token) async {
    if(state == AuthState.loaded) {
      return ;
    }
    // setState(AuthState.loading);
    apiResult = await UsersAPI().getUserByToken(token);
    setState(AuthState.loaded);
    if (!apiResult.hasError) {
      user = apiResult.data;
    } else {
      errorMessage = "provider error";
      setState(AuthState.error);
    }
  }

  updateUser(token,firstName,lastName,phone) async {
    setState(AuthState.loading);

    apiResult = await UsersAPI().updateUserProfile(token,firstName,lastName,phone);

    if (!apiResult.hasError) {
      user = apiResult.data;
      setState(AuthState.loaded);
    } else {
      errorMessage = "provider error";
      setState(AuthState.error);
    }
  }

  logout (){
    setState(AuthState.initial);

  }
  setState(state) {
    this.state = state;
    notifyListeners();
  }
}
