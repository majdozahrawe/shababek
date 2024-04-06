import 'package:flutter/material.dart';
import 'package:shababeek/catagory/user_profile.dart';
import 'package:shababeek/components/contact_us.dart';
import 'package:shababeek/components/privacy_policy.dart';
import 'package:shababeek/components/compliants.dart';

import 'package:shababeek/providers/auth_provider.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:shababeek/sign_up/sign_up_screen.dart';
import 'package:shababeek/splash/start_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../components/default_button.dart';

import '../animations/drive_animation.dart';
import '../factory_shababeek.dart';
import '../providers/otp_provider.dart';
import 'notification.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late OtpProvider otpProvider;


  Future<void> showCustomDialog(BuildContext context) async {
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
                            "لا يمكن لمزودي الخدمة تغيير معلوماتهم الشخصية من خلال التطبيق",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          "لتغيير معلوماتك الشخصية تواصل معنا",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.center,
                        ),

                        DefaultButton(
                          button_width: 200,
                          fontSize: 14,
                          backcolor: Color(0xFF03ADD0),
                          text: "تواصل معنا",
                          press: () async {
                            Navigator.of(context).push(createRoute(ContactUs()));
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


  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    print("drawer opend");
    authProvider = Provider.of<AuthProvider>(context);
    otpProvider = Provider.of<OtpProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image:  DecorationImage(
                    image: AssetImage("assets/images/window.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Container(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              backgroundImage:
                              AssetImage('assets/images/s_logo.png'),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(createRoute(UserProfile()));
                            },
                            child: Text(
                              // "siuu",
                              authProvider.user.firstName.toString()
                                  +" "+authProvider.user.lastName.toString() ,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                          authProvider.user.isWorker?"مزود خدمة": "" ,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home,color: Color(0xFF03ADD0),),
                title: const Text('الصفحة الرئيسية',
                  style: TextStyle(
                  fontWeight: FontWeight.w600,
                    fontSize: 13,
                  color: Color(0XFF888888),
                  fontFamily: 'Cairo',
                ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: Icon(Icons.person,color: Color(0xFF03ADD0)),
                title: const Text('الصفحة الشخصية',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0XFF888888),
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {
                  if(authProvider.user.isWorker == false){
                    Navigator.of(context).push(createRoute(UserProfile()));

                  }
                  else{
                    showCustomDialog(context);
                  }


                },
              ),
              ListTile(
                leading: Icon(Icons.notifications,color: Color(0xFF03ADD0)),
                title: const Text('الإشعارات',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0XFF888888),
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {
                    Navigator.of(context).push(createRoute(NotificationScreen()));


                },
              ),
              ListTile(
                leading: Icon(Icons.person,color: Color(0xFF03ADD0)),
                title: const Text('تواصل معنا',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0XFF888888),
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(createRoute(ContactUs()));
                },
              ),


              ListTile(
                leading: Icon(Icons.edit,color: Color(0xFF03ADD0)),
                title: const Text('التسجيل كمزود خدمة',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0XFF888888),
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(createRoute(ContactUs()));
                  },
              ),
              ListTile(
                leading: Icon(Icons.book,color: Color(0xFF03ADD0)),
                title: const Text('الشروط والقيود',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0XFF888888),
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(createRoute(PrivacyPolicy()));

                },
              ),
              // ListTile(
              //   leading: Icon(Icons.person),
              //   title: const Text('الشكاوي'),
              //   onTap: () {
              //     Navigator.of(context).push(createRoute(ShaqaweScreen()));
              //
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.logout,color: Color(0xFF03ADD0)),
                title: const Text('تسجيل الخروج',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0XFF888888),
                    fontFamily: 'Cairo',
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("تأكيد تسجيل الخروج"),
                        content: Text("هل أنت متأكد من رغبتك في تسجيل الخروج؟"),
                        actions: [
                          TextButton(
                            child: Text("إلغاء"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("تأكيد"),
                            onPressed: () {
                              // Perform logout actions here
                               removeToken();




                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> removeToken() async {
    final  SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Remove Token auth befoooor : ${preferences.getString("token_user")}");


    await preferences.remove('token_user');
    
 

    authProvider.logout();
    otpProvider.logout();
    print("Remove Token auth afterrrrrr : ${authProvider.state}");

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SignInScreen(),
        transitionDuration: Duration(seconds: 1), // Set transition duration to 1 second
        reverseTransitionDuration: Duration(seconds: 1), // Set reverse transition duration to 1 second
      ),
    );

    print('Token removed from storage.');
  }
}


