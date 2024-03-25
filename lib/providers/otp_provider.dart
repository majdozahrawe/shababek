
import 'package:flutter/material.dart';
import 'package:shababeek/data/api/otp_api.dart';
import 'package:shababeek/data/models/otp_model.dart';

import '../data/api/api_result.dart';
import '../data/api/worker_api.dart';
import '../data/models/user_model.dart';
import '../data/models/worker_details_model.dart';
import '../data/models/worker_model.dart';



enum OtpState{initial, loading, loaded, error}
class OtpProvider with ChangeNotifier {
  OtpState state = OtpState.initial;

  late OtpModel otpModel;
  bool loading = false;
  late APIResult apiResult;
  late String errorMessage;

  getOtp(phone) async {
    setState(OtpState.loading);

    apiResult = await OtpAPI().otpRequest(phone);

    // print("Api result : ${apiResult.data}");
    // print("Api result Error  : ${apiResult.hasError}");

    if(!apiResult.hasError){
      otpModel = apiResult.data;
      setState(OtpState.loaded);


    }else{
      print("error on otp state");
      errorMessage = apiResult.failure.message;
      setState(OtpState.error);
    }

    print("Status : ${state}");
    return apiResult;
  }
  getPhoneOtp(phone) async {
    setState(OtpState.loading);

    apiResult = await OtpAPI().SendOtpToPhone(phone);

    // print("Api result : ${apiResult.data}");
    // print("Api result Error  : ${apiResult.hasError}");

    if(!apiResult.hasError){
      otpModel = apiResult.data;
      setState(OtpState.loaded);


    }else{
      print("error on otp state");
      errorMessage = apiResult.failure.message;
      setState(OtpState.error);
    }

    print("Status : ${state}");
    return apiResult;
  }

  logout (){
    setState(OtpState.initial);
  }
  setState(state){
    this.state = state;
    notifyListeners();
  }
}