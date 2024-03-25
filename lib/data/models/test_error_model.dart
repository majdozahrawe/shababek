// class ErrorModel{
//   int code;
//   UserMessages messages;
//   String accessToken;
//   // ErrorModel();
//   //
//   factory ErrorModel.fromJson(Map<String, dynamic>json){
//     ErrorModel e = ErrorModel();
//     d.code = json['code'];
//     d.developerMessage = json['developer_message'];
//     d.messages = UserMessages.fromJson(json['user_messages']);
//     d.accessToken = json['access_token'];
//     return d;
//   }
//
// }
// class UserMessages{
//   String message;
//   UserMessages();
//   factory UserMessages.fromJson(Map<String, dynamic>json){
//     UserMessages userMessages = UserMessages();
//
//     userMessages.message = json['en'];
//
//     return userMessages;
//   }
//
// }