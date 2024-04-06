import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shababeek/data/models/otp_model.dart';
import 'package:shababeek/data/models/otp_response.dart';
import 'package:shababeek/data/models/worker_model.dart';
import 'dart:convert';
import 'package:shababeek/data/models/worker_response.dart';
import '../models/failure.dart';
import '../models/worker_details_model.dart';
import 'api_response_handler.dart';
import 'api_result.dart';


class OtpAPI {

  APIResult result = APIResult();
  String convertToFlutterFormat(String phoneNumber) {
    // Assuming the input phone number is in a specific format (e.g., without country code)
    String countryCode = "962"; // Change this to the desired country code

    // Remove any leading zeros or other non-numeric characters
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'^0+'), ''); // Remove leading zeros
    // Concatenate the country code with the cleaned phone number
    String flutterFormattedNumber = countryCode + cleanedPhoneNumber;

    return flutterFormattedNumber;
  }

  Future<APIResult> otpRequest(phone) async {
      var _formatedPhone = convertToFlutterFormat(phone);

      print("Formated Phone Number : {$_formatedPhone} ");

      var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/OTP/Fake/$_formatedPhone';

    Map<String,String> headers = {'Content-Type':'application/json'};
    final response = await http.get(Uri.parse(url),headers: headers,);

    OtpResponse otpResponse;
    var jsonResponse = jsonDecode(response.body);


    try {
      if (response.statusCode == 200) {
        otpResponse = OtpResponse.fromJson(jsonResponse);
        result.hasError = false;

        result.data = otpResponse.data;
        print("Hellooooooo 2");

      } else {
        jsonResponse = jsonDecode(response.body);
        otpResponse = OtpResponse.fromJson(jsonResponse);

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['error']);
      }
    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

      return result;
  }

  Future<APIResult> SendOtpToPhone(String phone) async {
    var _formatedPhone = convertToFlutterFormat(phone);

    print("Formated Phone Number : {$_formatedPhone} ");
    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Password/Fake/OTP/$_formatedPhone';


    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      'phone': phone,
    });

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg
    );

    OtpResponse otpResponse;
    var jsonResponse = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print("phone Success");

        otpResponse = OtpResponse.fromJson(jsonResponse);

        result.hasError = false;
        result.data = otpResponse.data;
      } else {
        jsonResponse = jsonDecode(response.body);
        otpResponse = OtpResponse.fromJson(jsonResponse);

        result.hasError = true;
        result.failure = Failure(400, jsonResponse['message']);
      }
    } catch (ex) {
      result = APIResponseErrorHandler.parseError(ex);
    }

    return result;
  }


}