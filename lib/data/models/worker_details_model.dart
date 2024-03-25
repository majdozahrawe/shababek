



class WorkerDetailsModel {
   String id;
  // experiance;

  String? firstName;
  String? lastName;
  String? phone;
  var experience;

  var distance;
  // final String image;
  var totalRatingAvarage, totalRating;
  var workerLocation;


  WorkerDetailsModel({
    this.firstName ,
    this.lastName ,
    this.totalRatingAvarage = 0,
    this.totalRating = 0,
    this.id = '',
    this.distance = 0.0,
    this.workerLocation,
    this.experience,
    this.phone
  });

   factory WorkerDetailsModel.fromJson(Map<String, dynamic> json) {
     return WorkerDetailsModel(
         firstName: json['data']['firstName']??" ",
         id: json['data']['_id']??" ",
         lastName: json['data']['lastName']?? "",
         phone: json['data']['phone']?? "",
       totalRatingAvarage: json['data']['totalRatingAvarage']?? 0.0,
       totalRating: json['data']['totalRating']?? 0.0,
       distance: json['data']['distance']?? 0.0,
       experience: json['data']['experience']?? 0,
     );
     }

  // factory WorkerDetailsModel.fromJson(Map<String, dynamic> json) {
  //   return Worker1(
  //     firstName: json['firstName']??" ",
  //     id: json['_id']??" ",
  //     lastName: json['lastName']?? "",
  //     totalRatingAvarage: json['totalRatingAvarage']?? "",
  //     totalRating: json['totalRating']?? "",
  //     phone: json['phone']?? "",
  //     distance: json['distance']?? "",
  //     workerLocation: json['location']?? {},
  //   );
  // }
  //
  //
  //
  // static List<Worker1> fromJsonList(dynamic jsonList) {
  //   final List<Worker1> worker1List = [];
  //   for (final json in jsonList["data"]) {
  //     worker1List.add(
  //       Worker1.fromJson(json),
  //     );
  //   }
  //   return worker1List;
  // }

// return Worker1(
//   id: json['id']?? " ",
//   firstName: json['firstName']??" ",
//   lastName: json['lastName']?? "",
//   // rating: json['rating'],
//   // totalRating: json['totalRating'],
//   // distance: json['distance'],
//   // l: json['location'],
//   );
//
// }


}