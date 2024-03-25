class AdsModel {
  String id,adsImage;

  AdsModel({ required this.id , required this.adsImage});

  factory AdsModel.fromJson(Map<String,dynamic> json){
    AdsModel s = AdsModel(id:"",adsImage: "");
    s.id = json['_id'].toString();
    s.adsImage = json['adsImage'].toString();

    return s;
  }

}