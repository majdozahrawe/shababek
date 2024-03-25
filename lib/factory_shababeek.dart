import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:shababeek/HomeScreen/home_screen.dart';
import 'package:shababeek/components/no_location_screen.dart';
import 'package:shababeek/providers/lat_lon_provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shababeek/splash/splash_screen.dart';
import 'package:shababeek/splash/start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../animations/drive_animation.dart';
import '../data/app_constants.dart';
import '../data/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../providers/ads_provider.dart';
import '../providers/auth_provider.dart';
import 'components/default_button.dart';

enum LoggedIn{initial, yes, no}


class FactoryShababeek extends StatefulWidget {
  @override
  _FactoryShababeekState createState() => _FactoryShababeekState();
}

class _FactoryShababeekState extends State<FactoryShababeek> {
  bool _locationServiceEnabled = false;
  late String? token;
   LoggedIn  is_logged_in = LoggedIn.initial;
  late AuthProvider authProvider;
  late AdsProvider adsProvider;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late LatLonProvider latLonProvider;

  Future<Position> getUserCurrentLocation2() async {
    print("need location");
    await Geolocator.getCurrentPosition().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR Majd 2 " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  Future<void> checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(serviceEnabled) {
      getUserCurrentLocation2().then((value) async {

        latLonProvider.loadLocation(
            value.latitude.toString(), value.longitude.toString());
        latLonProvider.locationIsExist = true;
        print("value $value");

      });
    }

    setState(() {
      _locationServiceEnabled = serviceEnabled;
    });

    // // If not enabled, request location service
    // if (!serviceEnabled) {
    //   serviceEnabled = await Geolocator.openLocationSettings();
    // }

    // Check location permission
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, show error message or handle it gracefully
    //     return;
    //   }
    // }

    // If everything is enabled and permission is granted
    // if (serviceEnabled && permission == LocationPermission.whileInUse) {
    //
    // }
  }

  Future<void> showCustomDialog(BuildContext context) async {
    return showPlatformDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Stack(
              children: [
                // Close icon in the top right corner
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close), // You can customize the icon
                    onPressed: () {
                      // Navigator.pop(context); // Close the dialog
                    },
                  ),
                ),
                Container(
                  height: 390,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Image.network(
                          'https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317756/no_internet_dmphue.png',
                          height: 190,
                          width: 190,
                        ),
                      ),
                      Text(
                        'لا يوجد اتصال بالإنترنت',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      DefaultButton(
                        button_width: 200,
                        fontSize: 18,
                        backcolor: Color(0xFF03ADD0),
                        text: "محاولة مرة اخرى",
                        press: () async {
                          Navigator.pop(context, 'Cancel');
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            showCustomDialog(context);
                            setState(() => isAlertSet = true);
                          }
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // getConnectivity() {
  //   subscription = Connectivity().onConnectivityChanged.listen(
  //     (ConnectivityResult result) async {
  //       isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //       // Check if the device is connected
  //       if (isDeviceConnected) {
  //         setState(() => isAlertSet = false);
  //       } else if (!isAlertSet) {
  //         showCustomDialog(context);
  //         setState(() => isAlertSet = true);
  //       }
  //     },
  //   );
  // }


 // checkConnectivity() async {
 //    ConnectivityResult result = await Connectivity().checkConnectivity();
 //    isDeviceConnected = await InternetConnectionChecker().hasConnection;
 //    if (!isDeviceConnected && isAlertSet == false) {
 //      showCustomDialog(context);
 //      setState(() => isAlertSet = true);
 //    }
 //  }

  isLoggedin() {
    print("iam here bilal is logged in fun");
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        is_logged_in = sharedPrefValue.getString('token')!= null?LoggedIn.yes:LoggedIn.no;
        token = sharedPrefValue.getString('token');
      });
    });
    print("isLoggedin function");
  }


  @override
  void initState() {
    isLoggedin();
    // checkConnectivity();
    checkLocationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    adsProvider = Provider.of<AdsProvider>(context);
    latLonProvider = Provider.of<LatLonProvider>(context);


    if(is_logged_in == LoggedIn.no) return SignInScreen();
    print("After if in factory");

    if (is_logged_in == LoggedIn.yes && authProvider.state != AuthState.loaded) {
      print("load user now....");
      authProvider.loadUser(token);
    }

    if (is_logged_in == LoggedIn.yes && adsProvider.state != AdsState.loaded) {
      print("AdsState In gen_tokeen  : ${adsProvider.state}");
      adsProvider.loadAdsImage();
    }
    if(is_logged_in == LoggedIn.yes && !_locationServiceEnabled) return  NoLocationScreen();
    print("homeScreen");

    if(is_logged_in == LoggedIn.yes ){
      return HomeScreen();
    }

    print("logied $is_logged_in");
    // circle
    return Center(child: CircularProgressIndicator(color: Colors.red,));

  }
}
