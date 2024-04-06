import 'package:flutter/material.dart';
import 'package:shababeek/data/api/users_api.dart';
import 'package:shababeek/data/models/change_password_model.dart';
import 'package:shababeek/sign_in/forgotten_password/change_password.dart';

import '../data/api/api_result.dart';
import '../data/api/change_password_api.dart';
import '../data/models/user_model.dart';

enum ChangePasswordState { initial, loading, loaded, error }

class ChangePasswordProvider with ChangeNotifier {
  ChangePasswordState state = ChangePasswordState.initial;
  late ChangePasswordModel changePassword;
  late APIResult apiResult;
  late String errorMessage;

  changePasswordRequest(userId,newPassword) async {
    setState(ChangePasswordState.loading);

    apiResult = await ChangePasswordAPI().changePasswordRequest(userId,newPassword);

    if (!apiResult.hasError) {
      changePassword = apiResult.data;
      setState(ChangePasswordState.loaded);
    } else {
      errorMessage = "provider error";
      setState(ChangePasswordState.error);
    }
  }

  setState(state) {
    this.state = state;
    notifyListeners();
  }
}
