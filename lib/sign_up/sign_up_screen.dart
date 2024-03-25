import 'package:flutter/material.dart';
import 'package:shababeek/otp/otp_screen.dart';
import 'package:shababeek/providers/otp_provider.dart';
import 'package:shababeek/providers/signup_provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../HomeScreen/home_screen.dart';
import '../animations/drive_animation.dart';
import '../components/default_button.dart';
import '../components/privacy_policy.dart';
import '../constants.dart';
import '../providers/register_info_provider.dart';
import '../splash/start_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/signUp";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;

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
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.close), // You can customize the icon
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
  bool isFormSubmitted = false; // Add this line


  late String messageFromApi;

  static final GlobalKey<FormState> _regKey = GlobalKey<FormState>();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmpasswordController = TextEditingController();

  late SignUpProvider signUpProvider;
  late RegisterInfoProvider registerInfoProvider;
  late OtpProvider otpProvider;

  @override
  Widget build(BuildContext context) {
    print("signUp");

    signUpProvider = Provider.of<SignUpProvider>(context);
    otpProvider = Provider.of<OtpProvider>(context);
    registerInfoProvider = Provider.of<RegisterInfoProvider>(context);

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
      return OtpPage();
    }
    // SizeConfig().init(context);
    return _SignUpPage();
  }

  Widget _SignUpPage() {
    return Scaffold(
      backgroundColor: const Color(0XFFF1F1F6),
      body: SizedBox(
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: () async =>
              Provider.of<SignUpProvider>(context, listen: false)
                  .notifyListeners(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          child: const Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "حساب جديد",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _SignUpForm(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _SignUpForm() {
    bool visible = false;

    TextFormField buildFirstNameFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: firstnameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (isFormSubmitted) {
            if (value!.isNotEmpty && value.length > 3) {
              return null;
            } else if (value.isEmpty) {
              return "أدخل الإسم الأول";
            }else if (value.length > 15 && value.isNotEmpty) {
              return "يجب ان لا يزيد الاسم الأول عن 15 حرف";
            } else if (value.length < 3 && value.isNotEmpty) {
              return "يجب ان لا يقل الإسم عن 3 احرف";
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

    TextFormField buildLastNameFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: lastnameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (isFormSubmitted) {
            if (value!.isNotEmpty && value.length > 3) {
              return null;
            } else if (value.length > 15 && value.isNotEmpty) {
              return "يجب ان لا يزيد اسم العائلة عن 15 حرف";
            }
            else if (value.isEmpty) {
              return "أدخل إسم العائلة";
            } else if (value.length < 3 && value.isNotEmpty) {
              return "يجب ان لا يقل الإسم عن 3 احرف";
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
          } else if (value.length > 10 && value.isNotEmpty) {
            return "يجب ان لا يزيد رقم الهاتف عن 10 ارقام";
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
          hintStyle: TextStyle(
            color: Colors.black38,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ), // Set the color of the hint text
          hintText: "07xxxxxxxx",
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _regKey,
      child: Column(
        children: [
          Row(
            children: [
              // Second Column
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(75, 0, 0, 0),
                      child: const FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "إسم العاىلة",
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
                      height: 18,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/2.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.2),
                        //     spreadRadius: 2,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 1),
                        //   ),
                        // ],
                      ),
                      child: buildLastNameFormField(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),

              // First Column
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(75, 0, 0, 0),
                      child: const FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "الإسم الأول",
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
                      height: 18,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/2.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.2),
                        //     spreadRadius: 2,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 1),
                        //   ),
                        // ],
                      ),
                      child: buildFirstNameFormField(),
                    ),
                  ],
                ),
              ),

            ],
          ),

          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(260, 0, 0, 0),
            child: const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
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
            height: 18,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, 1),
                //   ),
                // ],
              ),
              child: buildPhoneFormField()),

          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(260, 0, 0, 0),
            child: const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
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
            height: 18,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, 1),
                //   ),
                // ],
              ),
              child: buildPasswordFormField()),

          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(240, 0, 0, 0),
            child: const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
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
            height: 18,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, 1),
                //   ),
                // ],
              ),
              child: buildConformPassFormField()),

          // FormError(errors: errors),
          const SizedBox(height: 40),
          SizedBox(
            width: (200),
            height: 56,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF03ADD0),
              ),
              onPressed: isLoading
                  ? null
                  : () {

                setState(() {
                  isFormSubmitted = true;
                });
                      if (_regKey.currentState!.validate()) {
                        _regKey.currentState!.save();

                        print("register Button Clicked");
                        print("First Name : ${firstnameController.text}");


                        registerInfoProvider.setRegInfo(firstnameController.text,
                            lastnameController.text, phoneController.text, passwordController.text);

                        otpProvider.getOtp(phoneController.text);


                        print("otp state after : ${otpProvider.state}");

                      }
                    },
              child: isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                    )
                  : const Text(
                      "إنشاء الحساب",
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
            ),
          ),
          Visibility(
              visible: visible,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: const CircularProgressIndicator())),
        ],
      ),
    );
  }
}
