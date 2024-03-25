import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:shababeek/HomeScreen/home_screen.dart';
import 'package:shababeek/providers/otp_provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'components/default_button.dart';


class LoginSuccessScreen extends StatelessWidget {

  late OtpProvider otpProvider;
  @override
  Widget build(BuildContext context) {
    otpProvider = Provider.of<OtpProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // Execute your custom logic here
        print("Back button pressed!");
        otpProvider.logout();

        // If you want to allow the back navigation, return true.
        // If you want to prevent the back navigation, return false.
        // For example, you can show a confirmation dialog and return its result.
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.network(
                "https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317761/success_eioxti.png",
                fit: BoxFit.cover,
              ),
              Spacer(),
              Text(
                "تم تسجيل الحساب بنجاح",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                child: DefaultButton(
                  text: "تسجيل الدخول الآن",
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => SignInScreen(),
                        transitionDuration: Duration(seconds: 2),  // Set the transition duration to 2 seconds
                        reverseTransitionDuration: Duration(seconds: 2),  // Set the reverse transition duration to 2 seconds
                      ),
                    );
                  },
                  fontSize: 18,
                  backcolor: Color(0xFF03ADD0),
                  button_width:20),
                ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
