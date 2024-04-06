import 'package:flutter/material.dart';
import 'package:shababeek/components/default_button.dart';
import 'package:shababeek/providers/auth_provider.dart';
import 'package:shababeek/providers/category_provider.dart';
import 'package:shababeek/providers/worker_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/my_drawer.dart';
import '../components/rating_stars.dart';
import '../data/app_constants.dart';
import '../data/models/favourite_model.dart';
import '../delete_done_page.dart';
import '../providers/worker_provider.dart';
import '../sign_in/sign_in_screen.dart';

class UserProfile extends StatefulWidget {
  static String routeName = "/worker_profile";

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool iSfirstNameChanged = false;
  bool iSLastNameChanged = false;
  bool iSPhoneChanged = false;
  bool isFormSubmitted = false; // Add this line
  late String messageFromApi;


  Map<TextEditingController, String> _initialValues = {};

  late TextEditingController firstnameController =
  TextEditingController.fromValue(
      TextEditingValue(text: authProvider.user.firstName));

  late TextEditingController lastnameController =
  TextEditingController.fromValue(
      TextEditingValue(text: authProvider.user.lastName));

  late TextEditingController phoneController = TextEditingController.fromValue(
      TextEditingValue(text: authProvider.user.phone));

  bool hasValueChanged(TextEditingController controller) {
    return controller.text != _initialValues[controller.text];
  }

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
                      'تم حفظ معلوماتك بنجاح',
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
                      text: "حسناً",
                      press: () {
                        Navigator.pop(context);
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

  void showToast() {
    Fluttertoast.showToast(
      msg: 'لم يتم تغيير اي معلومة',
      toastLength: Toast.LENGTH_SHORT,
      // Duration: Toast.LENGTH_SHORT or Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM,
      // Position: ToastGravity.TOP, ToastGravity.CENTER, or ToastGravity.BOTTOM
      backgroundColor: Color(0xFF03ADD0),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  late String? token;

  late AuthProvider authProvider;


  GlobalKey<FormState> _savedUpdate = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.state == AuthState.error) {
      authProvider.setState(AuthState.initial);

      messageFromApi = authProvider.errorMessage;
      Future.delayed(Duration.zero, () {
        showErrorCustomDialog(context, messageFromApi);
      });
    }
    return Scaffold(
        backgroundColor: Color(0XFFF1F1F6),
        appBar: AppBar(
          title: Text(
            "الصفحة الشخصية",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20),
                Column(children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Image.asset(
                        "assets/images/worker_image_profile.png",
                        scale: 2,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  _UpdateForm(),

                  SizedBox(height: 20),

                  // Container(
                  //   child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(30),
                  //       child: Image.asset('assets/images/elictric.jpg',)
                  //   ),
                  // ),
                ]),
              ]),
            ),
          ),
        ));
  }

  void _loadToken() async {
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        token = sharedPrefValue.getString('token_user');
      });
    });
  }

  Widget _UpdateForm() {
    TextFormField buildFirstNameFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: firstnameController,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          setState(() {
            iSfirstNameChanged = true;
          });
        },
        validator: (value) {
          if (value!.isNotEmpty && value.length > 3) {
            return null;
          } else if (value.isEmpty) {
            return "أدخل الإسم الأول";
          } else if (value.length < 3 && value.isNotEmpty) {
            return "يجب ان لا يقل الإسم عن 3 احرف";
          }
        },
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red)),
            labelStyle: TextStyle(
              fontSize: 20,
            ),
            filled: true,
            fillColor: Color(0xFFFFFFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10))),
      );
    }

    TextFormField buildLastNameFormField() {
      return TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: lastnameController,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          setState(() {
            iSLastNameChanged = true;
          });
        },
        validator: (value) {
          if (value!.isNotEmpty && value.length > 3) {
            return null;
          } else if (value.isEmpty) {
            return "أدخل إسم العائلة";
          } else if (value.length < 3 && value.isNotEmpty) {
            return "يجب ان لا يقل الإسم عن 3 احرف";
          }
        },
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red)),
            labelStyle: TextStyle(
              fontSize: 20,
            ),
            filled: true,
            fillColor: Color(0xFFFFFFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10))
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10),

        ),
      );
    }
    return Form(
      key: _savedUpdate,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(260, 0, 0, 0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: buildFirstNameFormField()),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.fromLTRB(260, 0, 0, 0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: buildLastNameFormField()),
          SizedBox(height: 30),
          SizedBox(height: 30),
          Center(
            child: DefaultButton(
              button_width: 300,
              fontSize: 18,
              backcolor: Color(0xFF03ADD0),
              text: "حفظ",
              press: () {
                if (_savedUpdate.currentState!.validate() &&
                    (iSPhoneChanged ||
                        iSfirstNameChanged ||
                        iSLastNameChanged)) {
                  _savedUpdate.currentState!.save();
                  showCustomDialog(context);
                  setState(() {
                    iSPhoneChanged = false;
                    iSfirstNameChanged = false;
                    iSLastNameChanged = false;
                  });
                  authProvider.updateUser(token, firstnameController.text,
                      lastnameController.text, phoneController.text);
                } else {
                  showToast();
                }
              },
            ),
          ),
          SizedBox(height: 30),


          GestureDetector(
            onTap: (){

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Define a TextEditingController to capture the password input
                  TextEditingController passwordController = TextEditingController();

                  return AlertDialog(
                    title: Text("تأكيد حذف الحساب",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: (18),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView( // Use SingleChildScrollView to ensure the dialog is scrollable if needed
                      child: ListBody(
                        children: <Widget>[
                          Text("يرجى إعادة ادخال كلمة المرور لتأكيد حذف الحساب",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: (14),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20), // Add some space before the password field
                          // Password TextFormField
                          Container(
                            padding: EdgeInsets.fromLTRB(210, 0, 0, 0),
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
                          TextFormField(
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
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("إلغاء",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: (14),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("تأكيد",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: (14),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isFormSubmitted = true;
                          });
                          // Use the password from the TextEditingController
                          String password = passwordController.text;
                          // // Perform logout actions here
                          removeToken();
                          authProvider.logout();
                          print("helooooooooo in takeed");
                          print(authProvider.user.phone.toString()+" "+ password);
                          authProvider.delete(authProvider.user.phone.toString(), password);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => DeleteScreen(),
                              transitionDuration: Duration(seconds: 1), // Set transition duration to 1 second
                              reverseTransitionDuration: Duration(seconds: 1), // Set reverse transition duration to 1 second
                            ),
                          );
                          print(authProvider.state);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(205, 0, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: const Text(
                  "حذف الحساب",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.redAccent,
                    fontSize: (14),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
void removeToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.remove('token_user');
  print('Token removed from storage.');
}
