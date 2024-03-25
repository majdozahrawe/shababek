class CompliantModel {
  String id,text,compliant_token;

  CompliantModel({ required this.id , required this.text,required this.compliant_token,
  });

  factory CompliantModel.fromJson(Map<String,dynamic> json){
    CompliantModel c = CompliantModel(text: "",id: "",compliant_token: "");
    c.id = json['_id'].toString();
    c.text = json['text'].toString();
    c.compliant_token = json['token'].toString();
    return c;
  }

}