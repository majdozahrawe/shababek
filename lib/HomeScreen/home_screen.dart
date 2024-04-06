import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shababeek/providers/ads_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shababeek/components/my_drawer.dart';
import 'package:shababeek/providers/worker_location_provider.dart';
import 'package:shababeek/splash/start_screen.dart';
import 'package:shababeek/HomeScreen/componants/cards.dart';
import 'package:shababeek/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../animations/drive_animation.dart';
import '../components/contact_us.dart';
import '../components/default_button.dart';
import '../data/app_constants.dart';
import '../data/models/category_model.dart';
import '../providers/category_provider.dart';
import '../sign_in/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int indicatorIndex = 0;


  List<Categories>? categorieslist;

  late CategoriesGridProvider provider;
  late AdsProvider adsProvider;
  late AuthProvider authProvider;
  late WorkerLocationProvider workerLocationProvider;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final _pageController = PageController(viewportFraction: 0.877);

  double currentPage = 0;

  @override
  Widget build(BuildContext context) {
    print("homeee");
    provider = Provider.of<CategoriesGridProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    adsProvider = Provider.of<AdsProvider>(context);
    workerLocationProvider = Provider.of<WorkerLocationProvider>(context);

    if (authProvider.state !=AuthState.loaded){
      return SignInScreen();
    }

    // SizeConfig().init(context);
    if(provider.state != GridScreenState.loaded ) {
      // authProvider.setState(AuthState.initial);
      provider.loadCategories();
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0XFFF1F1F6),
          elevation: 0.0,
        ),// Shimmer screen
            body: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: SizedBox(
                      height: 170,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF03ADD0),
                          borderRadius: BorderRadius.circular(20
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 7,
                          width: 50,
                          color: Colors.white,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8)),
                        Container(
                          height: 10,
                          width: 75,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/1.4,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: categorieslist?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 0.2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
    }
    // if (provider.state == GridScreenState.initial) {
    //   provider.loadCategories();
    //   // workerLocationProvider.loadWorkerLocation(latitude, longitude);
    //   return Center(child: CircularProgressIndicator());
    // }
    else {
      categorieslist = provider.categoriesList;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFFF1F1F6),
      body: RefreshIndicator(
        child: _buildCategoryScreen(),
        onRefresh: () async =>
            Provider.of<CategoriesGridProvider>(context, listen: false)
                .loadCategories(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0XFF03ADD0),
                ),
                onPressed: () {
                  Navigator.of(context).push(createRoute(ContactUs()));
                },
                child: const Text(
                  "التسجيل كمزود خدمة",
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.51),
                child: IconButton(
                  icon: Image.asset("assets/images/nav.png", width: 28),
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      endDrawer: NavDrawer(),
    );
  }

  _buildCategoryScreen() {
    return Scaffold(
      backgroundColor: Color(0XFFF1F1F6),
      body: SafeArea(
        child: Column(
          children: [
            adsProvider.state == AdsState.initial?CircularProgressIndicator(color: Colors.red,):Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0,left: 8),
                  child: CarouselSlider.builder(
                    itemBuilder: (context, index, realIndex) {
                      return Transform.scale(
                        scale: index == _index ? 0.82 : 0.82 ,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              NetworkImage(adsProvider.adsModel.length==0?
                              "https://res.cloudinary.com/dmrb3gva0/image/upload/v1701529196/samples/ecommerce/accessories-bag.jpg"
                                  :adsProvider.adsModel[index].adsImage.toString()
                                ,),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      );
                    }, itemCount: adsProvider.adsModel.length,

                    options: CarouselOptions(
                      height: 180.0,
                      onPageChanged: (index, reason) {
                        indicatorIndex = index;
                      },
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1.2,
                    ),

                  ),

                ),
                DotsIndicator(
                  dotsCount: adsProvider.adsModel.length==0?1:adsProvider.adsModel.length,
                  position: indicatorIndex,
                  decorator: DotsDecorator(
                    color: Color(0XFFC5C5C5),
                    activeColor:  Color(0XFF03ADD0),
                  ),

                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCategoryListHeader(), _buildCategoryList()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCategoryListHeader() {
    return Column(children: [

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "الخدمات",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ]);
  }

  _buildCategoryList() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: categorieslist?.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0),
        itemBuilder: (BuildContext context, int index) {
          return CategoryCard(categories: categorieslist![index]);
        },
      ),
    );
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