class AddCountModel {
  String id;
  String? worker;
  String? date;
  var countDetails, countPhoneCall;



  AddCountModel({

    this.id = '',
    this.worker,
    this.date,
    this.countDetails,
    this.countPhoneCall,
  });

  factory AddCountModel.fromJson(Map<String, dynamic> json) {

    return AddCountModel(
      id: json['_id']??" ",
      worker: json['worker']??" ",
      date: json['date']??" ",
      countDetails: json['countDetails']??" ",
      countPhoneCall: json['countPhoneCall']??" ",
    );
  }

}


