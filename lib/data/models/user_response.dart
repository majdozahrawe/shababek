
import 'user_model.dart';

class UserResponse {
  late User data;

  UserResponse();

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    UserResponse userResponse = UserResponse();
    if (json['data'] != null) userResponse.data = User.fromJson(json['data']);

    return userResponse;
  }

}

