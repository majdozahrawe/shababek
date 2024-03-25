import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'my_drawer.dart';


class ContactUs extends StatefulWidget {

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final GlobalKey<ScaffoldState> contact_us = GlobalKey<ScaffoldState>();
  // var url = 'https://www.facebook.com/profile.php?id=61554842826260';


  @override
  Widget build(BuildContext context) {

    buildCustomCard(String title, String subtitle, String imageAsset, Function press) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.93,
        height: MediaQuery.of(context).size.height * 0.09,
        child: Card(
          color: Colors.white,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            onTap: press as void Function()?,
            contentPadding: EdgeInsets.only(top:5,right: 10),
            trailing: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.network(imageAsset),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Scaffold(
        backgroundColor: Color(0XFFF1F1F6),
        key: contact_us,
          appBar: AppBar(
            title: Text(
              "تواصل معنا",
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 150,
                  width: 150,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: Image.network(
                      "https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317757/s_logo_iu1vov.png",
                      scale: 2,),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.83,
                  height: MediaQuery.of(context).size.height * 0.12,
                  child:Text(
                    " يمكنك التواصل معنا عبر واتس آب, سيتم التواصل معك في غضون 24 ساعة\n \nشكراً لتواصلكم معنا",

                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0XFF888888),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(

                  children: [
                    buildCustomCard("خدمة العملاء شبابيك","متوفر", "https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317755/c_whatsapp_xhhykp.png",(){
                      whatsapp();
                    }),

                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: 2, // Adjust height as needed
                            child: Container(
                              color: Color(0XFF888888), // Adjust color as needed
                            ),
                          ),
                        ),
                        Text(
                          "تابعنا عبر",

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0XFF888888),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cairo',
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: 2, // Adjust height as needed
                            child: Container(
                              color: Color(0XFF888888), // Adjust color as needed
                            ),
                          ),
                        ),

                      ],
                    ),


                    SizedBox(height: 10), // Add spacing between cards
                    buildCustomCard("شبابيك - Shababeek","متوفر",
                        "https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317754/c_face_ax2sr4.png",(){
                          _launchFacebook();
                    }),
                    buildCustomCard("@Shababeek.p","متوفر", "https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317755/c_insta_soavep.png",(){}),
                    SizedBox(height: 10), // Add spacing between cards

                  ],
                ),
              ),
            ),


          ],
        )
      ),


    );

  }

}
whatsapp() async{
  var contact = "+962781798577";
  var androidUrl = "whatsapp://send?phone=$contact&text=مرحباً, أحتاج بعض المساعدة";
  var iosUrl = "https://wa.me/$contact?text=${Uri.parse('مرحباً, أحتاج بعض المساعدة')}";

  try{
    if(Platform.isIOS){
      await launchUrl(Uri.parse(iosUrl));
    }
    else{
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception{
    print('WhatsApp is not installed.');
  }
}


_launchFacebook() async {
  final facebookUrl = "fb://profile/61554842826260"; // Use the Facebook URL scheme
  final fallbackUrl = "https://www.facebook.com/61554842826260"; // Fallback URL for browsers

  if (await canLaunch(facebookUrl)) {
    await launch(facebookUrl);
  } else {
    await launch(fallbackUrl);
  }
}