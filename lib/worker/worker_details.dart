import 'package:flutter/material.dart';
import 'package:shababeek/catagory/user_profile.dart';
import 'package:shababeek/components/default_button.dart';
import 'package:shababeek/providers/category_provider.dart';
import 'package:shababeek/providers/worker_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import '../animations/drive_animation.dart';
import '../components/compliants.dart';
import '../components/my_drawer.dart';
import '../components/rating_stars.dart';
import '../data/app_constants.dart';
import '../data/models/favourite_model.dart';
import '../data/models/worker_model.dart';
import '../providers/add_count_provider.dart';
import '../providers/lat_lon_provider.dart';
import '../providers/worker_provider.dart';
import '../sign_in/sign_in_screen.dart';

class WorkerDetails extends StatefulWidget {

Worker1 _worker;

WorkerDetails({required Worker1 worker}) : _worker = worker;

  @override
  State<WorkerDetails> createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
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
                      'تم إضافة الفني الى الفنيين المفضلين',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    DefaultButton(
                      button_width: 20,
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

  bool initial = true;

  late Favorite favorite;

  late bool isFav = false;

  // late Favorite favorite;
  int _index = 0;

  late WorkerProvider workerProvider;

  late WorkerProfileProvider workerProfileProvider;
  late LatLonProvider latLonProvider;

  late CategoriesGridProvider categoriesGridProvider;
  late AddCountProvider addCountProvider;

  @override
  Widget build(BuildContext context) {

print(widget._worker);

    workerProfileProvider = Provider.of<WorkerProfileProvider>(context);
    workerProvider = Provider.of<WorkerProvider>(context);
    categoriesGridProvider = Provider.of<CategoriesGridProvider>(context);
    addCountProvider = Provider.of<AddCountProvider>(context);
    latLonProvider = Provider.of<LatLonProvider>(context);





    return Scaffold(
      backgroundColor: Color(0XFFF1F1F6),
      appBar: AppBar(
        title: Text(
          categoriesGridProvider.categoryName,
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
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
    Column(
      children: [
        Container(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Image.asset("assets/images/worker_image_profile.png",scale: 4,),
                ),
              ),

        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Text
                  (widget._worker.firstName.toString()
                    +" "+widget._worker.lastName.toString(),
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),

                child: Text
                  ( "الخبرة : "+widget._worker.experience.toString()+ " سنوات ",
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Color(0xff545454),
                      fontWeight: FontWeight.w500),
                ),

              ),
              SizedBox(height: 20,),


              ElevatedButton.icon(

                onPressed: () {
                  addCountProvider.AddOneCount(widget._worker.id.toString(), true);
                  var pnum = widget._worker.phone.toString();
                  launch('tel:$pnum');
                  },
                icon: Icon(Icons.call_outlined,color: Colors.white,),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width/1.5,50),
                ),
                label: Text(
                  'الإتصال',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),






            ],
          ),
        ),
      ],
    ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrapped the first container with Expanded
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10,left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(createRoute(ShaqaweScreen(worker: widget._worker)));
                                  // Navigator.of(context).push(createRoute(UserProfile()));
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(110, 50),
                                ),
                                child: Text(
                                  'تقديم شكوى',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),



                      // Wrapped the third container with Expanded
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10,right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  openMaps();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFF03ADD0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(110, 50),
                                ),
                                child: Text(
                                  'اذهب',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),),

         Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child:RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style:  TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Color(0xff545454),
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(text: " : ",
                          style:  TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w700),),
                        TextSpan(text: ' عن  '),
                        TextSpan(text: widget._worker.firstName.toString(),
                          style:  TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.83,
                    height: MediaQuery.of(context).size.height * 0.12,
                    child:Text(
                      " يمكنك التواصل معنا عبر واتس آب, سيتم التواصل معك في غضون 24 ساعة  يمكنك التواصل معنا عبر واتس آب, سيتم التواصل معك في غضون 24 ساعة يمكنك التواصل معنا عبر واتس آب, سيتم التواصل معك في غضون 24 ساعة يمكنك ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0XFF888888),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),


                Container(
            child:RichText(
              text: TextSpan(
                style:  TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Color(0xff545454),
                    fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(text: " : ",
                    style:  TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w700),),
                  TextSpan(text: 'صور من  '),
                  TextSpan(text: widget._worker.firstName.toString(),
                      style:  TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700),),
                ],
              ),
            ),
                      ),

                SizedBox(height:
                MediaQuery.of(context).size.height * 0.02,),



                widget._worker.workingImages.length==0?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317656/no_image_kjcmvp.png",scale: 2.5,),
                      ),
                      SizedBox(height: 20,),

                      Text(
                        'لا يوجد صور',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                ):
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height/5,// Set the desired height
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget._worker.workingImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 20,
                      ),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(
                                  imageUrl: widget._worker.workingImages[index].toString(),
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: "imageHero2",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                // ",",
                                widget._worker.workingImages[index].toString(),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ]
          ),

        ),
        ]
      ),
    ),
    ),
    )
    );


  }

  void openMaps() async {
    double lat =  widget._worker.workerLocation['coordinates'][1];
    double lon = widget._worker.workerLocation['coordinates'][0];


    // Construct the Google Maps URL with the destination coordinates
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

}
class DetailScreen extends StatelessWidget {
  final String imageUrl;

  // Constructor to receive the image URL
  DetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              imageProvider: NetworkImage(imageUrl), // Pass the URL to NetworkImage
            ),
          ),


          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0, // Remove AppBar elevation
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
