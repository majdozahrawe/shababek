import 'package:flutter/material.dart';
import 'package:shababeek/HomeScreen/home_screen.dart';
import 'package:shababeek/catagory/workers_screen.dart';
import 'package:shababeek/components/no_location_screen.dart';
import 'package:shababeek/data/api/worker_api.dart';
import 'package:shababeek/providers/worker_profile_provider.dart';
import 'package:shababeek/providers/worker_provider.dart';
import 'package:provider/provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shababeek/data/models/worker_response.dart';

import '../../animations/drive_animation.dart';
import '../../data/api/api_response_handler.dart';
import '../../data/api/api_result.dart';
import '../../data/models/category_model.dart';
import '../../data/models/worker_model.dart';
import '../../worker/worker_details.dart';
import '../../providers/category_provider.dart';
import '../../providers/lat_lon_provider.dart';
import '../../providers/worker_location_provider.dart';
import 'package:geolocator/geolocator.dart';

class CategoryCard extends StatefulWidget {
  Categories _category;

  CategoryCard({required Categories categories}) : _category = categories;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late CategoriesGridProvider categoriesGridProvider;

  late WorkerProvider workerProvider;

  late LatLonProvider latLonProvider;

  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
  }

  // Function to get the user's current location
  // void _getCurrentLocation() async {
  //   try {
  //     // Get current location
  //     _currentPosition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //     setState(() {});
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    categoriesGridProvider = Provider.of<CategoriesGridProvider>(context);
    workerProvider = Provider.of<WorkerProvider>(context);
    latLonProvider = Provider.of<LatLonProvider>(context);

    Future<void> checkLocationService() async {
      bool serviceEnabled;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        categoriesGridProvider.setCategoryID(widget._category.id);
        categoriesGridProvider.getCategoryName(widget._category.category_name);
        workerProvider.loadWorker(latLonProvider.lat, latLonProvider.longot,
            categoriesGridProvider.categoryID.toString());

      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                NoLocationScreen(),
            transitionDuration: Duration.zero,
            // Set the transition duration to 2 seconds
            reverseTransitionDuration: Duration
                .zero, // Set the reverse transition duration to 2 seconds
          ),
        );
        // categoriesGridProvider.loadCategories();

      }
    }



    Widget categoryCard = _buildCategoryCard();
    return GestureDetector(
        onTap: () async {
          checkLocationService();
          Navigator.of(context).push(createRoute(
              WorkerScreen()));

        },
        child: categoryCard);
  }

  Widget _buildCategoryCard() {
    Widget cardContent = _buildCategoryCardContent(widget._category);
    return Card(
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: cardContent,
    );
  }

  Widget _buildCategoryCardContent(Categories categories) {
    Widget categoryImage = _buildCategoryImage(widget._category.image_url);
    Widget categoryTitle = _buildCategoryTitle(widget._category.category_name);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        categoryImage,
        SizedBox(height: 10),
        categoryTitle,
      ],
    );
  }

  Widget _buildCategoryImage(String image) {
    if (image == "") {
      //default image
      image = 'assets/images/1.png';
    }
    return Image.network(
      image,
      scale: 1.2,
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.black87),
    );
  }
}
