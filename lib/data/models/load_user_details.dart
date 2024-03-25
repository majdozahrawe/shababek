// To parse this JSON data, do
//
//     final loadUserModel = loadUserModelFromJson(jsonString);

import 'dart:convert';

LoadUserModel loadUserModelFromJson(String str) => LoadUserModel.fromJson(json.decode(str));

String loadUserModelToJson(LoadUserModel data) => json.encode(data.toJson());

class LoadUserModel {
  String? status;
  String? token;
  Data? data;

  LoadUserModel({
    this.status,
    this.token,
    this.data,
  });

  factory LoadUserModel.fromJson(Map<String, dynamic> json) => LoadUserModel(
    status: json["status"],
    token: json["token"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "data": data?.toJson(),
  };
}

class Data {
  Location? location;
  String? id;
  String? firstName;
  String? lastName;
  String? password;
  int? totalRating;
  int? rating;
  List<String>? categories;
  bool? active;
  bool? isBlocked;
  String? phone;
  String? rule;
  bool? isWorker;
  String? experience;
  int? v;

  Data({
    this.location,
    this.id,
    this.firstName,
    this.lastName,
    this.password,
    this.totalRating,
    this.rating,
    this.categories,
    this.active,
    this.isBlocked,
    this.phone,
    this.rule,
    this.isWorker,
    this.experience,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    password: json["password"],
    totalRating: json["totalRating"],
    rating: json["rating"],
    categories: json["categories"] == null ? [] : List<String>.from(json["categories"]!.map((x) => x)),
    active: json["active"],
    isBlocked: json["isBlocked"],
    phone: json["phone"],
    rule: json["rule"],
    isWorker: json["isWorker"],
    experience: json["experience"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "password": password,
    "totalRating": totalRating,
    "rating": rating,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x)),
    "active": active,
    "isBlocked": isBlocked,
    "phone": phone,
    "rule": rule,
    "isWorker": isWorker,
    "experience": experience,
    "__v": v,
  };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}
