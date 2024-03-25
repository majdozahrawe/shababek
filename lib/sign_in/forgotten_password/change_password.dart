import 'dart:convert';
import 'package:shababeek/changed_successfully.dart';
import 'package:shababeek/providers/change_password_provider.dart';
import 'package:shababeek/providers/otp_provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:shababeek/sign_up/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../animations/drive_animation.dart';
import 'forgotten_otp.dart';

class ChangePaswordScreen extends StatefulWidget {

  @override
  State<ChangePaswordScreen> createState() => _ChangePaswordScreenState();
}

class _ChangePaswordScreenState extends State<ChangePaswordScreen> {

  late ChangePasswordProvider changePasswordProvider;
  late OtpProvider otpProvider;



  GlobalKey<FormState> _changekey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isFormSubmitted = false; // Add this line

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmpasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => BackButtonDialog(),
          ) ?? false;},

        child: _SignPage());
  }

  Widget _SignPage() {
    changePasswordProvider = Provider.of<ChangePasswordProvider>(context);
    otpProvider = Provider.of<OtpProvider>(context);

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
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "إنشاء كلمة مرور جديدة",
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

    TextFormField buildConformPassFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: ConfirmpasswordController,
        obscureText: true,
        validator: (value) {
          if (isFormSubmitted) {
            if (value!.isNotEmpty && value.length > 5) {
              return null;
            } else if (value!.isEmpty) {
              return "أدخل تأكيد كلمة المرور";
            } else if (value != passwordController.text) {
              return "الكلمة التي ادخلتها لا تطابق كلمة المرور";
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
      key: _changekey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(230, 0, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: const Text(
                  "كلمة المرور الجديدة",
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
                child: buildPasswordFormField()),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.fromLTRB(230, 0, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: const Text(
                  "تأكيد كلمة المرور",
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
                child: buildConformPassFormField()),
            SizedBox(height: 10),

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
                onPressed: isLoading ? null:(){
                  if (_changekey.currentState!.validate()) {
                    _changekey.currentState!.save();
                    setState(() {
                      isFormSubmitted = true;
                    });

                    changePasswordProvider.changePasswordRequest(otpProvider.otpModel.id.toString(),
                        ConfirmpasswordController.text);

                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => ChangeSuccessScreen(),
                        transitionDuration: Duration(seconds: 2),  // Set the transition duration to 2 seconds
                        reverseTransitionDuration: Duration(seconds: 2),  // Set the reverse transition duration to 2 seconds
                      ),
                    );
                    print("Login Button Clicked");


                  }
                },
                child: isLoading
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                )
                    : Text(
                  "تأكيد",
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
class BackButtonDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("الخروج من الصفحة"),
      content: Text("هل تريد الخروج وعدم حفظ المعلومات؟"),
      actions: <Widget>[
        TextButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop(false); // Dismiss dialog and do not exit
          },
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => SignInScreen(),
                transitionDuration: Duration(seconds: 2),  // Set the transition duration to 2 seconds
                reverseTransitionDuration: Duration(seconds: 2),  // Set the reverse transition duration to 2 seconds
              ),
            );          },
        ),
      ],
    );
  }
}
