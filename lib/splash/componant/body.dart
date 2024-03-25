import 'package:flutter/material.dart';
import 'package:shababeek/HomeScreen/home_screen.dart';
import 'package:shababeek/components/default_button.dart';
import 'package:shababeek/sign_in/sign_in_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../sign_up/sign_up_screen.dart';

class Body extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: (20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 35,
                      child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317757/s_logo_iu1vov.png"),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "S H A B A - B E E K",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: (14),
                         fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317761/splash_tahys4.png",
                scale: 0.9,),

                // Container(
                //   width: 300,
                //     child: Image.asset("assets/images/splash.png"),
                // ),
                 SizedBox(height: 20),

                  Column(
                    children: [
                      Center(
                        child: Text(
                          "....مرحباًً",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: (24),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      SizedBox(
                        width: 320,
                        child: Center(
                          child: Text(
                            "تطبيق شبابيك يساعد في تسهيل وصولك للفنيين الأقرب اليك, انضم الينا الآن.",
                            style: TextStyle(
                              color: Color(0XFF5D5D5D),
                              fontSize: (13),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Cairo',

                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                        child: Row(
                          children: [

                            Expanded(
                              flex: 1,
                              child: DefaultButton(
                                  press: () {


                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignInScreen()));
                                  },
                                  backcolor: Color(0XFF03ADD0),
                                  fontSize: 17,
                                  button_width:(150),
                                  text: "تسجيل الدخول",
                              ),
                            ),
                            SizedBox(width: 20),


                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 160,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignUpScreen()));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:MaterialStateProperty.all(Color(0XFFF1F1F6)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(width: 2, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "حساب جديد",
                                    style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black
                                    ),

                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 160,
                            //   height: getProportionateScreenHeight(56),
                            //   child: OutlinedButton(
                            //     onPressed: null,
                            //     style: ButtonStyle(
                            //       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                            //
                            //       )),
                            //     ),
                            //     child: const Text(
                            //         "حساب جديد",
                            //       style: TextStyle(
                            //         fontFamily: 'Cairo',
                            //         fontSize: 17,
                            //         fontWeight: FontWeight.w400,
                            //         color: Colors.black
                            //       ),
                            //
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "تواصل معنا عبر ",
                          style: TextStyle(
                            color: Color(0XFF757575),
                            fontSize: (18),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [

                          Expanded(
                            flex: 1,
                            child: FloatingActionButton(
                              heroTag: "fb_btn",
                              foregroundColor: Colors.black,
                              backgroundColor:  Colors.white,
                              mini: false,
                              onPressed: () {
                                // Respond to button press
                              },
                              child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317754/facebook_vdksuh.png",width: 30,)
                            ),
                          ),
                          SizedBox(width: 20),

                          Expanded(
                            flex: 1,
                            child: FloatingActionButton(
                                heroTag: "insta_btn",
                                foregroundColor: Colors.black,
                                backgroundColor:  Colors.white,
                                mini: false,
                                onPressed: () {
                                  // Respond to button press
                                },
                                child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317755/instagram_ve2i8v.png",width: 30,)
                            ),
                          ),
                          SizedBox(width: 20),

                          Expanded(
                            flex: 1,
                            child: FloatingActionButton(
                                heroTag: "lin_btn",
                                foregroundColor: Colors.black,
                                backgroundColor:  Colors.white,
                                mini: false,
                                onPressed: () {
                                  // Respond to button press
                                },
                                child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317755/linkedin_ehuw0y.png",width: 30,)
                            ),
                          ),

                        ],
                      ),


                    ],
                  ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
