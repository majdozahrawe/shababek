import 'package:shababeek/data/models/add_count_model.dart';

class AddCountResponse {
  late AddCountModel data;
  AddCountResponse();

  factory AddCountResponse.fromJson(Map<String,dynamic>json){
    AddCountResponse addCountResponse = AddCountResponse();
    if (json['data'] != null) addCountResponse.data = AddCountModel.fromJson(json['data']);

    return addCountResponse;
  }
}