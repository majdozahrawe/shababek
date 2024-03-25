// import 'package:flutter/material.dart';
//
// class NoLocationBottom extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       color: Colors.white,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             leading: Icon(Icons.photo),
//             title: Text('From Gallery'),
//             onTap: () {
//               // Handle action from gallery
//               Navigator.pop(context); // Close the bottom sheet
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.camera),
//             title: Text('Take a Photo'),
//             onTap: () {
//               // Handle action to take a photo
//               Navigator.pop(context); // Close the bottom sheet
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:shababeek/HomeScreen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../animations/drive_animation.dart';
import '../providers/lat_lon_provider.dart';
import 'default_button.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';



class NoLocationScreen extends StatefulWidget {
  @override
  State<NoLocationScreen> createState() => _NoLocationScreenState();
}

class _NoLocationScreenState extends State<NoLocationScreen> with WidgetsBindingObserver {

  Geolocator geolocator = Geolocator();

  bool _locationServiceEnabled = false;


  bool _appHasFocus = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appHasFocus = state == AppLifecycleState.resumed;
    });
  }
  late LatLonProvider latLonProvider;

  Future<Position> getUserCurrentLocation() async {
    print("need location");
    try {
      var permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        return await Geolocator.getCurrentPosition();
      } else {
        print("Permission denied");
        // Handle permission denied scenario
      }
    } catch (e) {
      print("Error: $e");
      // Handle other errors
    }
    throw Exception('net error');
  }


  @override
  Widget build(BuildContext context) {
    latLonProvider = Provider.of<LatLonProvider>(context);

    checkLocationService();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network(
              "https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317756/no_loc_home_gqk78f.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4), // Adjust opacity and color as needed
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'خدمات الموقع غير متاحة',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'يرجى السماح لخدمات الموقع عن طريق الضغط على الزر في الأسفل',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: (200),
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF03ADD0),
                        ),
                        icon: Icon(Icons.location_on_outlined,color: Colors.white,), // Specify the icon here
                        onPressed: () {
                          getUserCurrentLocation().then((value) async {
                            latLonProvider.loadLocation(
                                value.latitude.toString(), value.longitude.toString());
                            print(" value in no location ${value.longitude}");
                            latLonProvider.locationIsExist = true;
                          });
                        },
                        label: Text('تشغيل الموقع'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkLocationService() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled){

      getUserCurrentLocation().then((value) async {

        latLonProvider.loadLocation(
            value.latitude.toString(), value.longitude.toString());
        latLonProvider.locationIsExist = true;
        print("value $value");

      });


      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomeScreen(),
          transitionDuration: Duration.zero,  // Set the transition duration to 2 seconds
          reverseTransitionDuration: Duration.zero,  // Set the reverse transition duration to 2 seconds
        ),
      );    }

  }
}
