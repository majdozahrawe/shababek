
import 'package:provider/provider.dart';

import 'dart:collection';


class PhoneOtpModel {

  // String? otp_date;
  // String? phone;

  var otp;


  PhoneOtpModel({
    // this.otp_date,
    // this.phone,
    this.otp,

  });

  factory PhoneOtpModel.fromJson(Map<String, dynamic> json) {
    return PhoneOtpModel(
      // otp_date: json['data']['otp_date'] ?? "",
      // phone: json['data']['phone'] ?? "",
      otp: json['otp'] ?? 0,
    );
  }
}