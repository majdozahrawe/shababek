import 'package:flutter/material.dart';

import '../splash/componant/body.dart';

class StartScreen extends StatelessWidget {
  static String routeName = "/splash";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF1F1F6),
      body: Body(),
    );
  }
}
