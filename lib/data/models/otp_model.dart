
import 'package:provider/provider.dart';

import 'dart:collection';


class OtpModel {

  // String? otp_date;
  // String? phone;

  var otp;
  var id;


  OtpModel({
    // this.otp_date,
    // this.phone,
    this.otp,
    this.id,

  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      // otp_date: json['data']['otp_date'] ?? "",
      // phone: json['data']['phone'] ?? "",
      otp: json['otp'] ?? 0,
      id: json['user']['_id'] ?? 0,
    );
  }
}