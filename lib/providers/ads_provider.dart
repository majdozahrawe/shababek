
import 'package:flutter/material.dart';
import 'package:shababeek/data/api/ads_api.dart';
import 'package:shababeek/data/models/ads_model.dart';


enum AdsState{initial, loading, loaded, error}
class AdsProvider with ChangeNotifier{
  AdsState state = AdsState.initial;

  late List<AdsModel> adsModel;


  loadAdsImage() async {
    print("AdsState : $state");
    adsModel = await AdsAPI().getAdsImage();
    state = AdsState.loaded;
    print("AdsState : $state");
    notifyListeners();
  }
}