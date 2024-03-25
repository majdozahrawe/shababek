import 'package:http/http.dart' as http;
import 'package:shababeek/data/models/ads_model.dart';
import 'package:shababeek/data/models/ads_response.dart';
import 'dart:convert';


import '../models/user_response.dart';


class AdsAPI {

  Future<List<AdsModel>> getAdsImage() async {

    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Banner/All';

    http.Response response = await http.get(Uri.parse(url),);

    AdsResponse adsResponse = AdsResponse();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      adsResponse = AdsResponse.fromJson(jsonResponse);
    }

    else {
      print('Request failed with status : ${response.statusCode}.');
    }
    return adsResponse.data;

  }
}