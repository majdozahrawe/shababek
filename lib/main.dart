import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:shababeek/data/models/change_password_model.dart';
import 'package:shababeek/factory_shababeek.dart';
import 'package:shababeek/providers/add_count_provider.dart';
import 'package:shababeek/providers/ads_provider.dart';
import 'package:shababeek/providers/category_provider.dart';
import 'package:shababeek/providers/change_password_provider.dart';
import 'package:shababeek/providers/compliant_provider.dart';
import 'package:shababeek/providers/lat_lon_provider.dart';
import 'package:shababeek/providers/auth_provider.dart';
import 'package:shababeek/providers/network_provider.dart';
import 'package:shababeek/providers/otp_provider.dart';
import 'package:shababeek/providers/phone_number_provider.dart';
import 'package:shababeek/providers/register_info_provider.dart';
import 'package:shababeek/providers/signup_provider.dart';
import 'package:shababeek/providers/worker_location_provider.dart';
import 'package:shababeek/providers/worker_profile_provider.dart';
import 'package:shababeek/providers/worker_provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:shababeek/sign_up/sign_up_screen.dart';
import 'package:shababeek/splash/splash_screen.dart';
import 'package:shababeek/splash/start_screen.dart';
import 'package:shababeek/worker/worker_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'HomeScreen/home_screen.dart';
import 'catagory/workers_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // await FirebaseApi().;
  await Permission.notification.request();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');

    // Get the current time
    DateTime dateTime = DateTime.now().subtract(Duration(hours: 1));

    // Format the DateTime object into a relative time string
    String relativeTimeString = timeago.format(dateTime, locale: 'ar');

    // Format the DateTime object into a readable date and time string
    String dateTimeString = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    String timestamp = dateTimeString;

    // Save the notification title, body, and timestamp to local storage
    _saveNotificationToLocal(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      timestamp,
    );
  });

  runApp(


    MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoriesGridProvider>(create: (_) => CategoriesGridProvider(),),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(),),
        ChangeNotifierProvider<SignUpProvider>(create: (_) => SignUpProvider(),),
        ChangeNotifierProvider<LatLonProvider>(create: (_) => LatLonProvider(),),
        ChangeNotifierProvider<WorkerProvider>(create: (_) => WorkerProvider(),),
        ChangeNotifierProvider<WorkerLocationProvider>(create: (_) => WorkerLocationProvider(),),
        ChangeNotifierProvider<WorkerProfileProvider>(create: (_) => WorkerProfileProvider(),),
        ChangeNotifierProvider<AddCountProvider>(create: (_) => AddCountProvider(),),
        ChangeNotifierProvider<CompliantProvider>(create: (_) => CompliantProvider(),),
        ChangeNotifierProvider<OtpProvider>(create: (_) => OtpProvider(),),
        ChangeNotifierProvider<AdsProvider>(create: (_) => AdsProvider(),),
        ChangeNotifierProvider<RegisterInfoProvider>(create: (_) => RegisterInfoProvider(),),
        ChangeNotifierProvider<PhoneNumberProvider>(create: (_) => PhoneNumberProvider(),),
        ChangeNotifierProvider<ChangePasswordProvider>(create: (_) => ChangePasswordProvider(),),
        // ChangeNotifierProvider<NetworkProvider>(create: (_) => NetworkProvider(),),


      ],

      child: MyApp(),
    ),

  );

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");


  DateTime dateTime = DateTime.now().subtract(Duration(hours: 1));


  // Format the DateTime object into a readable date and time string
  String dateTimeString = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  String timestamp = dateTimeString;

  // Save the notification to local storage
 await _saveNotificationToLocal(
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    timestamp,
  );
}

Future<void> _saveNotificationToLocal(String title, String body, String timestamp) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get existing notifications or initialize empty lists
  List<String> notificationTitles = prefs.getStringList('notificationTitles') ?? [];
  List<String> notificationBodies = prefs.getStringList('notificationBodies') ?? [];
  List<String> notificationTimestamps = prefs.getStringList('notificationTimestamps') ?? [];

  // Add new notification to lists
  notificationTitles.add(title);
  notificationBodies.add(body);
  notificationTimestamps.add(timestamp);

  // Save lists back to local storage
  await prefs.setStringList('notificationTitles', notificationTitles);
  await prefs.setStringList('notificationBodies', notificationBodies);
  await prefs.setStringList('notificationTimestamps', notificationTimestamps);
}


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   // Save the notification title and body to local storage
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<String>? notificationTitles = prefs.getStringList('notificationTitles') ?? [];
//   List<String>? notificationBodies = prefs.getStringList('notificationBodies') ?? [];
//   notificationTitles.add(message.notification?.title ?? '');
//   notificationBodies.add(message.notification?.body ?? '');
//   await prefs.setStringList('notificationTitles', notificationTitles);
//   await prefs.setStringList('notificationBodies', notificationBodies);
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Scaffold(
          body: FactoryShababeek(),
        )
    );
  }


}
