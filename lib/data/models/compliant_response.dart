
import 'package:shababeek/data/models/compliant_model.dart';

class CompliantResponse {
  late CompliantModel data;

  CompliantResponse();

  factory CompliantResponse.fromJson(Map<String, dynamic> json) {
    CompliantResponse compliantResponse = CompliantResponse();
    if (json['data'] != null) compliantResponse.data = CompliantModel.fromJson(json['data']);

    return compliantResponse;
  }

}

