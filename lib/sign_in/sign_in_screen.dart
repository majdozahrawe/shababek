import 'dart:convert';
import 'package:shababeek/sign_in/forgotten_password/phone_page.dart';
import 'package:shababeek/sign_up/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../HomeScreen/home_screen.dart';
import '../animations/drive_animation.dart';
import '../components/custom_dialog.dart';
import '../components/default_button.dart';
import '../components/privacy_policy.dart';
import '../constants.dart';
import '../providers/ads_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/otp_provider.dart';
import '../splash/componant/body.dart';
import '../splash/start_screen.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/signIn";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late String messageFromApi;
  bool visible = false ;

  late AdsProvider adsProvider;

  Future<void> showErrorCustomDialog(BuildContext context, String message) async {
    return showPlatformDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!, // Use the current route's animation
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
                    height: MediaQuery.of(context).size.height / 2.5,
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
                            message,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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

  // bool isLoading = false;
  bool isFormSubmitted = false; // Add this line

  GlobalKey<FormState> _loginkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthProvider authProvider;
  late OtpProvider otpProvider;


  @override
  Widget build(BuildContext context) {

    print("Login Screen ");


    otpProvider = Provider.of<OtpProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    adsProvider = Provider.of<AdsProvider>(context);
    // otpProvider.logout();

    if (authProvider.state == AuthState.initial) {
      print("you in sign page nowwww");
      return _SignPage();
    }
    if(adsProvider.state !=AdsState.loaded){
      print("AdsState In gen_tokeen  : ${adsProvider.state}");
      adsProvider.loadAdsImage();
    }

    if (authProvider.state == AuthState.error) {
      authProvider.setState(AuthState.initial);

      messageFromApi = authProvider.errorMessage;
      Future.delayed(Duration.zero, () {
        showErrorCustomDialog(context, messageFromApi);
      });
      return _SignPage();
    }
    print("AuthProvider State :");

    print(authProvider.state);

    if (authProvider.state == AuthState.loaded) {
      print("good Login");
      return HomeScreen();

      }
    print("sign twwwoooo");
    return _SignPage();
  }

  Widget _SignPage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0XFFF1F1F6),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
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
                      "تسجيل الدخول",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: (12),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 130,
                  height: 130,
                  child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317757/s_logo_iu1vov.png"),
                ),
                SizedBox(height: 20),
                _SignForm(),
                SizedBox(height: 20),
                Text(
                  "تطبيق شبابيك يساعد في تسهيل وصولك للفنيين الأقرب اليك.",
                  style: TextStyle(
                    color: Color(0XFF5D5D5D),
                    fontSize: (13),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap:(){
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).push(createRoute(SignUpScreen()));
                  },
                  child: Text(
                    "تسجيل حساب جديد",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF03ADD0),
                      fontSize: (13),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
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
            }}
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
            borderSide: const BorderSide(color: Color(0xFFDADADA)), // Set the grey border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDADADA)), // Set the grey border color
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

    TextFormField buildPasswordFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          if (isFormSubmitted) {
            if (value!.isNotEmpty && value.length > 5) {
              return null;
            } else if (value.isEmpty) {
              return "أدخل كلمة المرور";
            } else if (value.length < 5 && value.isNotEmpty) {
              return "يجب ان لا تقل كلمة المرور عن 5 احرف او ارقام";
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
            borderSide: const BorderSide(color: Color(0xFFDADADA)), // Set the grey border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDADADA)), // Set the grey border color
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
      key: _loginkey,
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
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.fromLTRB(230, 0, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: const Text(
                  "كلمة المرور",
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
              child: buildPasswordFormField(),
            ),
            SizedBox(height: 10),

            GestureDetector(
              onTap: (){
                Navigator.of(context).push(createRoute(ReEnterPhoneScreen()));

              },
              child: Container(
                padding: EdgeInsets.fromLTRB(205, 0, 0, 0),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: const Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF03ADD0),
                      fontSize: (14),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

      SizedBox(
        width: (200),
        height: 56,
        child: TextButton(

          style: TextButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF03ADD0),
          ),
          onPressed: authProvider.state==AuthState.loading ? null:(){
            if (_loginkey.currentState!.validate()) {
              _loginkey.currentState!.save();
              setState(() {
                isFormSubmitted = true;
              });

              print("Login Button Clicked");

              // authProvider.setState(AuthState.initial);

              authProvider.login(phoneController.text.toString(),
                  passwordController.text.toString());

            }
          },
          child: authProvider.state==AuthState.loading
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          )
              : Text(
            "تسجيل الدخول",
              style: TextStyle(
                  fontFamily: 'Cairo' ,
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
              ),
          ),

        ),
      ),

          ],
        ),
      ),
    );
  }
}
