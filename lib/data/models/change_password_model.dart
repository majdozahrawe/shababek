class ChangePasswordModel {
  String id,newPassword;

  ChangePasswordModel({ required this.id , required this.newPassword,

  });

  factory ChangePasswordModel.fromJson(Map<String,dynamic> json){
    ChangePasswordModel c = ChangePasswordModel(newPassword: "",id: "",);
    c.id = json['user']['_id'].toString();
    c.newPassword = json['password'].toString();
    return c;
  }

}


class PasswordResponse {
  late ChangePasswordModel data;

  PasswordResponse();

  factory PasswordResponse.fromJson(Map<String, dynamic> json) {
    PasswordResponse userResponse = PasswordResponse();
    if (json['data'] != null) userResponse.data = ChangePasswordModel.fromJson(json['data']);

    return userResponse;
  }

}