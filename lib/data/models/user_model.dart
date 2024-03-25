class User {
  String id,firstName,lastName,phone,password,accessToken;
  bool isWorker;

  User({ required this.id , required this.firstName,
    required this.lastName,required this.phone,required this.password,
    required this.accessToken,required this.isWorker,

  });

  factory User.fromJson(Map<String,dynamic> json){
    User c = User(firstName: "",lastName: "",id: "",phone: "",password: "", accessToken: ''
        ,isWorker: false);
    c.id = json['_id'].toString();
    c.firstName = json['firstName'].toString();
    c.lastName = json['lastName'].toString();
    c.phone = json['phone'].toString();
    c.password = json['password'].toString();
    c.isWorker = json['isWorker'];
    c.accessToken = json['token'].toString();

    return c;
  }

}