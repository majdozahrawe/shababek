
import 'package:shababeek/data/models/compliant_model.dart';
import 'package:shababeek/data/models/otp_model.dart';

class OtpResponse {
  late OtpModel data;

  OtpResponse();

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    OtpResponse otpResponse = OtpResponse();
    if (json['data'] != null) otpResponse.data = OtpModel.fromJson(json['data']);

    return otpResponse;
  }

}