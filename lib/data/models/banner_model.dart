class BannertModel {
  String id,text,compliant_token;

  BannertModel({ required this.id , required this.text,required this.compliant_token,
  });

  factory BannertModel.fromJson(Map<String,dynamic> json){
    BannertModel b = BannertModel(text: "",id: "",compliant_token: "");
    b.id = json['_id'].toString();
    b.text = json['text'].toString();
    b.compliant_token = json['token'].toString();
    return b;
  }

}