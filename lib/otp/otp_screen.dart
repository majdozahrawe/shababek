import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shababeek/providers/register_info_provider.dart';
import 'package:shababeek/sign_up/sign_up_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../HomeScreen/home_screen.dart';
import '../animations/drive_animation.dart';
import '../catagory/workers_screen.dart';
import '../components/default_button.dart';
import '../login_success.dart';
import '../providers/otp_provider.dart';
import '../providers/signup_provider.dart';
import '../sign_in/sign_in_screen.dart';
import '../splash/start_screen.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  late Timer _timer;
  int _timerSeconds = 120; // Set the duration for the OTP timer in seconds
  bool _showResendText = false;



  late SignUpProvider signUpProvider;
  late OtpProvider otpProvider;
  late RegisterInfoProvider registerInfoProvider;
  String otp = "";
  late String messageFromApi;

  bool isLoading = false;

  Future<void> showCustomDialog(BuildContext context) async {
    return showPlatformDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(80),
            // Adjust the value as needed
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Container(
                height: 390,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),

                    Center(
                        child: Lottie.asset('assets/lottie/update_saved.json',
                            height: 190,
                            width: 190)), // Replace with your animation path
                    Text(
                      'تم إنشاء حسابك بنجاح',
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
                      text: "تسجيل الدخول",
                      press: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                SignInScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> showOtpErrorCustomDialog(BuildContext context) async {
    return showPlatformDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            // Use the current route's animation
            curve: Curves.ease, // Adjust the curve as needed
          ),
          child: ClipRRect(
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
                        Navigator.of(context).pop();
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
                          child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317764/wrong_klfxqb.png",
                            width: 100,
                            height: 100,),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "رمز التحقق الذي ادخلته غير مطابق",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DefaultButton(
                          button_width: 200,
                          fontSize: 18,
                          backcolor: Color(0xFF03ADD0),
                          text: "محاولة مرة اخرى",
                          press: () async {

                            Navigator.of(context).pop();
                            },
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel(); // Cancel the timer when it reaches 0
          _showResendText = true; // Set the flag to show the resend text
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    signUpProvider = Provider.of<SignUpProvider>(context);
    otpProvider = Provider.of<OtpProvider>(context);
    registerInfoProvider = Provider.of<RegisterInfoProvider>(context);

    if (signUpProvider.state == SignUpScreenState.loading) {
      isLoading = true;
    }

    if (signUpProvider.state == SignUpScreenState.loaded) {
      isLoading = false;
      signUpProvider.setState(SignUpScreenState.initial);
    }

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
        backgroundColor: Color(0XFFF1F1F6),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: (20)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StartScreen()));
                        },
                        child: Container(
                          child: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "العودة",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: (12),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2,),

                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'اهلاً بك مجدداً',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child:  Text(
                      "تطبيق شبابيك يساعد في تسهيل وصولك للفنيين الأقرب اليك, انضم الينا الآن.",
                      style: TextStyle(
                        color: Color(0XFF5D5D5D),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Cairo',

                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 50,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: PinCodeTextField(
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(

                        shape: PinCodeFieldShape.box,
                        selectedFillColor: Colors.red,
                        selectedColor: Colors.black,
                        inactiveColor: Colors.blue,
                        activeFillColor: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                      appContext: context,
                    ),
                  ),

                  SizedBox(height: 20),

                  _showResendText
                      ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _timerSeconds = 120;
                        _showResendText = false; // Reset the flag
                      });
                      _startTimer();
                    },
                    child: Text(
                      'إعادة ارسال الرمز',
                      style: TextStyle(
                        color: Color(0XFF5D5D5D),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                      : Text(
                    'الوقت المتبقي :  $_timerSeconds ثانية ',
                    style: TextStyle(
                      color: Color(0XFF5D5D5D),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',

                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: (200),
                    height: 56,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Color(0xFF03ADD0),
                      ),
                      onPressed: _showResendText?null:isLoading
                          ? null
                          : () {
                        print("OTP : $otp");
                        if (otp == otpProvider.otpModel.otp.toString()){
                          otpProvider.logout();

                          signUpProvider.register(registerInfoProvider.r_firstName.toString(),
                              registerInfoProvider.r_lastName.toString(),
                              registerInfoProvider.r_phone.toString(),
                              registerInfoProvider.r_password.toString());

                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => LoginSuccessScreen(),
                              transitionDuration: Duration.zero,  // Set the transition duration to 2 seconds
                              reverseTransitionDuration: Duration.zero,  // Set the reverse transition duration to 2 seconds
                            ),
                          );
                        }else{
                          showOtpErrorCustomDialog(context);
                        }
                      },
                      child: isLoading
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ],
                      )
                          : Text(
                        "إرسال",
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
