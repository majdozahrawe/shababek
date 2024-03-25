class ChangePassword {
  String id,newPassword;

  ChangePassword({ required this.id , required this.newPassword,

  });

  factory ChangePassword.fromJson(Map<String,dynamic> json){
    ChangePassword c = ChangePassword(newPassword: "",id: "",);
    c.id = json['_id'].toString();
    c.newPassword = json['password'].toString();
    return c;
  }

}