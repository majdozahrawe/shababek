import 'dart:async';
import 'dart:convert';
import 'package:shababeek/providers/phone_number_provider.dart';
import 'package:shababeek/sign_up/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../animations/drive_animation.dart';
import '../../components/default_button.dart';
import '../../providers/otp_provider.dart';
import 'forgotten_otp.dart';

class ReEnterPhoneScreen extends StatefulWidget {
  @override
  State<ReEnterPhoneScreen> createState() => _ReEnterPhoneScreenState();
}

class _ReEnterPhoneScreenState extends State<ReEnterPhoneScreen> {
  late PhoneNumberProvider phoneNumberProvider;
  late OtpProvider otpProvider;

  late Timer _timer;
  int _timerSeconds = 120; // Set the duration for the OTP timer in seconds
  bool _showResendText = false;
  GlobalKey<FormState> _phonekey = GlobalKey<FormState>();
  String phoneOtp = "";


  late String messageFromApi;

  // static final GlobalKey<FormState> _regKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFormSubmitted = false; // Add this line

  TextEditingController phoneController = TextEditingController();
  Future<void> showErrorCustomDialog(BuildContext context, String message) async {
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
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    // Close icon in the top right corner

                    Container(
                      height: 390,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317764/wrong_klfxqb.png",
                              width: 100,
                              height: 100,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Flexible(
                              child: Text(
                                message,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Cairo',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DefaultButton(
                            button_width: 200,
                            fontSize: 18,
                            backcolor: const Color(0xFF03ADD0),
                            text: "محاولة مرة اخرى",
                            press: () async {
                              Navigator.of(context).pop();

                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
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
    otpProvider = Provider.of<OtpProvider>(context);
    phoneNumberProvider = Provider.of<PhoneNumberProvider>(context);

    if (otpProvider.state == OtpState.error) {
      print("error on otp state");
      messageFromApi = otpProvider.errorMessage;
      Future.delayed(Duration.zero, () {
        showErrorCustomDialog(context, messageFromApi);
      });
      otpProvider.setState(OtpState.initial);
      print("otp state : ${otpProvider.state}");
    }

    if (otpProvider.state == OtpState.loading){
      setState(() {
        isLoading = true;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
    print("object");
    print(otpProvider.state );

    if (otpProvider.state == OtpState.loaded){
      return ForgottenOtpPage();
    }
    // SizeConfig().init(context);
    return _PhonePage();
  }

  Widget _PhonePage() {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0XFFF1F1F6),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'نسيت كلمة المرور؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                _SignForm(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _SignForm() {
    TextFormField buildPhoneFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.phone,
        controller: phoneController,
        validator: (value) {
          if (isFormSubmitted) {
            if (value!.isNotEmpty && value.length == 10) {
              return null;
            } else if (value.isEmpty) {
              return "أدخل  رقم الهاتف";
            } else if (value.length < 10 && value.isNotEmpty) {
              return "يجب ان لا يقل رقم الهاتف عن 10 ارقام";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xFFDADADA)), // Set the grey border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDADADA)),
            // Set the grey border color
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(
            fontSize: 20,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
        ),
      );
    }

    return Form(
      key: _phonekey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(230, 0, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: const Text(
                  "رقم الهاتف",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0XFF7A7A7A),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buildPhoneFormField()),
            SizedBox(height: 30),
            SizedBox(
              width: (200),
              height: 56,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF03ADD0),
                ),
                onPressed: _showResendText?null:isLoading
                    ? null
                    : () {

                  setState(() {
                    isFormSubmitted = true;
                  });
                  if (_phonekey.currentState!.validate()) {
                    _phonekey.currentState!.save();

                    print("phone : ${phoneController.text}");

                    phoneNumberProvider.setPhoneNumber(phoneController.text);
                    otpProvider.getPhoneOtp(phoneController.text);


                    print("otp state after : ${otpProvider.state}");

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
    );
  }
}
