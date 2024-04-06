
import 'package:provider/provider.dart';

import 'dart:collection';


class PhoneOtpModel {

  // String? otp_date;
  // String? phone;

  var id;



  PhoneOtpModel({
    // this.otp_date,
    // this.phone,
    this.id,

  });

  factory PhoneOtpModel.fromJson(Map<String, dynamic> json) {
    return PhoneOtpModel(
      // otp_date: json['data']['otp_date'] ?? "",
      // phone: json['data']['phone'] ?? "",
      id: json['user']['_id'] ?? 0,

    );
  }
}