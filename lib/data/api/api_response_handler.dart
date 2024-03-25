import 'dart:io';

import '../app_constants.dart';
import '../models/failure.dart';
import 'api_result.dart';


class APIResponseErrorHandler {
  static APIResult parseError(ex) {
    APIResult result = APIResult();

    if (ex is FormatException) {
      result.hasError = true;

      result.failure = Failure(AppConstants.ERROR_NO_BODY_PARSING_CODE,
          "Problem parsing data from the server");
    } else if (ex is SocketException) {
      result.hasError = true;
      result.failure = Failure(
          AppConstants.ERROR_NO_CONNECTION_CODE, "Can't connect to internet");
    } else {
      result.hasError = true;
      result.failure =
          Failure(AppConstants.ERROR_NO_CONNECTION_CODE, ex.toString());
    }

    return result;
  }
}