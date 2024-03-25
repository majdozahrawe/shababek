//
// import 'dart:async';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:flutter_dialogs/flutter_dialogs.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// import '../components/default_button.dart';
//
// enum NetworkState{connected, disconnected}
// class NetworkProvider with ChangeNotifier{
//   NetworkState state = NetworkState.disconnected;
//
//   late StreamSubscription subscription;
//   bool isDeviceConnected = false;
//   bool isAlertSet = false;
//
//
//   getConnectivity() {
//     subscription = Connectivity().onConnectivityChanged.listen(
//           (ConnectivityResult result) async {
//         isDeviceConnected = await InternetConnectionChecker().hasConnection;
//         if (!isDeviceConnected && isAlertSet == false) {
//           setState(() => isAlertSet = true);
//           setState(() => NetworkState.connected);
//
//         }
//       },
//     );
//   }
//
//   // showDialogBox() => showCupertinoDialog<String>(
//   //   context: context,
//   //   builder: (BuildContext context) => CupertinoAlertDialog(
//   //     title: const Text('No Connection'),
//   //     content: const Text('Please check your internet connectivity'),
//   //     actions: <Widget>[
//   //       TextButton(
//   //         onPressed: () async {
//   //           Navigator.pop(context, 'Cancel');
//   //           setState(() => isAlertSet = false);
//   //           isDeviceConnected =
//   //           await InternetConnectionChecker().hasConnection;
//   //           if (!isDeviceConnected && isAlertSet == false) {
//   //             showDialogBox();
//   //             setState(() => isAlertSet = true);
//   //           }
//   //         },
//   //         child: const Text('OK'),
//   //       ),
//   //     ],
//   //   ),
//   // );
//   setState(state) {
//     this.state = state;
//     notifyListeners();
//   }
//
// }