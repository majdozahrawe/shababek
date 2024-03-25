
import 'package:provider/provider.dart';

import 'dart:collection';


class Worker1 {
   final String id;
      // experiance;
   final bool isFavorite;
   String? firstName;
   String? experience;
   String? lastName;
   var workingImages;
   String? phone;

   var distance;
  // final String image;
   var totalRatingAvarage, totalRating;
   var workerLocation;


   Worker1({
     this.isFavorite = false,
     this.experience,
     this.firstName ,
     this.lastName ,
     this.totalRatingAvarage = 0,
     this.totalRating = 0,
     this.id = '',
     this.distance = 0.0,
     this.workerLocation,
     this.workingImages,
     this.phone
   });

  factory Worker1.fromJson(Map<String, dynamic> json) {
    return Worker1(
      firstName: json['firstName']??" ",
      experience: json['experience'],
      workingImages: json['workingImages']??[],
      id: json['_id']??" ",
      lastName: json['lastName']?? "",
      totalRatingAvarage: json['totalRatingAvarage']?? "",
      totalRating: json['totalRating']?? "",
      phone: json['phone']?? "",
      distance: json['distance']?? "",
      workerLocation: json['location']?? {},
    );
  }



   static List<Worker1> fromJsonList(dynamic jsonList) {
     final List<Worker1> worker1List = [];
       for (final json in jsonList["data"]) {
         worker1List.add(
           Worker1.fromJson(json),
         );
     }
     worker1List.sort((a, b) => a.distance.compareTo(b.distance));

     return worker1List;
  }

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