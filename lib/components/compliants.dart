import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shababeek/providers/compliant_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../HomeScreen/home_screen.dart';
import '../animations/drive_animation.dart';
import '../catagory/user_profile.dart';
import '../components/default_button.dart';
import '../data/models/worker_model.dart';
import '../login_success.dart';
import '../providers/worker_profile_provider.dart';
import '../providers/worker_provider.dart';
import '../splash/start_screen.dart';

class ShaqaweScreen extends StatefulWidget {
  Worker1 _worker;

  ShaqaweScreen({required Worker1 worker}) : _worker = worker;

  @override
  _ShaqaweScreenState createState() => _ShaqaweScreenState();
}

class _ShaqaweScreenState extends State<ShaqaweScreen> {
  TextEditingController compliantController = TextEditingController();
  GlobalKey<FormState> _complintKey = GlobalKey<FormState>();
  GlobalKey<FormState> _complintFormKey = GlobalKey<FormState>();

  late CompliantProvider compliantProvider;
  late WorkerProvider workerProvider;
  late String? token;

  void _loadToken() async {
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        token = sharedPrefValue.getString('token');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    // iSPhoneChanged = true;
  }

  bool isLoading = false;
  Future<void> showCompliantCustomDialog(BuildContext context) async {
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
                          child:  Lottie.asset(
                            'assets/lottie/update_saved.json',
                            height: 120,
                            width: 120,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "تم إرسال الشكوى بنجاح",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
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
                          text: "الصفحة الرئيسية",
                          press: () async {
                            Navigator.of(context).push(createRoute(HomeScreen()));
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

  // Future<void> showCustomDialog(BuildContext context) async {
  //   return showPlatformDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ClipRRect(
  //           borderRadius: BorderRadius.circular(80),
  //           // Adjust the value as needed
  //           child: Dialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(30.0)),
  //             child: Stack(
  //               children: [
  //                 // The Lottie animation
  //                 Positioned(
  //                   top: 0,
  //                   left: 0,
  //                   right: 0,
  //                   child: Lottie.asset(
  //                     'assets/lottie/update_saved.json',
  //                     height: 120,
  //                     width: 120,
  //                   ),
  //                 ),
  //                 // The Column widget
  //                 Positioned.fill(
  //                   child: Container(
  //                     height: MediaQuery.of(context).size.height / 2.5,
  //                     child: Center(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.all(8),
  //                             child: Text(
  //                               "تم إرسال الشكوى بنجاح",
  //                               style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 15,
  //                                 fontWeight: FontWeight.w700,
  //                                 fontFamily: 'Cairo',
  //                               ),
  //                               textAlign: TextAlign.center,
  //                             ),
  //                           ),
  //                           Text(
  //                             "نشكرك على ابداء رأيك ومساعدتنا\n في تحسين التطبيق",
  //                             style: TextStyle(
  //                               color: Colors.black38,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: 'Cairo',
  //                             ),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           DefaultButton(
  //                             button_width: 200,
  //                             fontSize: 18,
  //                             backcolor: Color(0xFF03ADD0),
  //                             text: "الصفحة الرئيسية",
  //                             press: () {
  //                               Navigator.of(context).push(createRoute(HomeScreen()));
  //                             },
  //                           ),
  //                           SizedBox(height: 10),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //           ));
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    compliantProvider = Provider.of<CompliantProvider>(context);
    workerProvider = Provider.of<WorkerProvider>(context);
    if (compliantProvider.state == CompliantState.loaded){
      isLoading = true;
    }

    return Scaffold(
      key: _complintKey,
      appBar: AppBar(
        title: Text(
          "الشكاوي",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0XFFF1F1F6),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317760/shkawi_iam2hc.png", scale: 3),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'هل لديك مشكلة مع ؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      widget._worker.firstName.toString() +" "+
                          widget._worker.lastName.toString(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.redAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ":اريد ان اقدم شكوى  ",
                        style: TextStyle(
                          color: Color(0XFF5D5D5D),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  buildShaqwaFormField(),
                  SizedBox(height: 36),
                ],
              ),

              SizedBox(
                width: (200),
                height: 56,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xFF03ADD0),
                  ),
                  onPressed: compliantProvider.state == CompliantState.loading ? null : (){
                          print("compliants Screen ID : ");
                          print(widget._worker.id);
                          compliantProvider.sendCompliant(
                              compliantController.text,
                              token,
                              widget._worker.id);

                          Future.delayed(Duration(seconds: 1), () {
                            showCompliantCustomDialog(context);
                          });




                  },
                  child: compliantProvider.state == CompliantState.loading ? Row(
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
    );
  }

  TextFormField buildShaqwaFormField() {
    return TextFormField(
      key: _complintFormKey,
      maxLines: 9,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      controller: compliantController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
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
          borderRadius: BorderRadius.circular(10),
        ), // Empty space to push the prefix to the right
      ),
    );
  }
}
