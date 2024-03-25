import 'package:shababeek/data/models/ads_model.dart';

class AdsResponse {
  late List<AdsModel> data;
  AdsResponse();

  factory AdsResponse.fromJson(Map<String,dynamic>json){
    AdsResponse adsResponse = AdsResponse();

    adsResponse.data = [];
    // print(catagoriesResponse.data);
    for(var s in json['data']){
      AdsModel temp = AdsModel.fromJson(s);
      adsResponse.data.add(temp as AdsModel);
    }
    return adsResponse;
  }
}