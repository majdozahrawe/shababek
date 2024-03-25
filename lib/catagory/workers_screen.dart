import 'dart:async';
import 'package:shababeek/providers/add_count_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shababeek/HomeScreen/home_screen.dart';
import 'package:shababeek/data/api/get_worker_details_api.dart';
import 'package:shababeek/data/api/worker_api.dart';
import 'package:shababeek/worker/worker_details.dart';
import 'package:shababeek/providers/category_provider.dart';
import 'package:shababeek/providers/lat_lon_provider.dart';
import 'package:shababeek/providers/worker_profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';


import '../animations/drive_animation.dart';
import '../components/my_drawer.dart';
import '../components/rating_stars.dart';
import '../data/models/category_model.dart';
import '../data/models/worker_model.dart';
import '../providers/worker_location_provider.dart';
import '../providers/worker_provider.dart';
import '../sign_in/sign_in_screen.dart';

class WorkerScreen extends StatefulWidget {
  WorkerScreen();

  @override
  _WorkerScreenState createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {

  bool initial = true;

  late LatLonProvider latLonProvider;
  late CategoriesGridProvider categoriesGridProvider;
  late WorkerProvider workerProvider;
  late AddCountProvider addCountProvider;
  late WorkerLocationProvider workerLocationProvider;

  GoogleMapController? _controller;


  late BitmapDescriptor pinLocationIcon;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      "assets/images/worker_marker.png",
    ).then((onValue) {
      pinLocationIcon = onValue;
      markers = _markers;

      Future.delayed(Duration(seconds: 2), () {
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          if (workerProvider.listWorkers.isEmpty) {
            initial = true;
          } else {
            initial = false;
          }

          setState(() {
            _markers = Iterable.generate(
              workerProvider.listWorkers.length,
                  (index) {
                return Marker(
                  markerId: MarkerId(
                    workerProvider.listWorkers[index].lastName.toString(),
                  ),
                  position: LatLng(
                    double.parse(workerProvider.listWorkers[index]
                        .workerLocation['coordinates'][1]
                        .toString()),
                    double.parse(workerProvider.listWorkers[index]
                        .workerLocation['coordinates'][0]
                        .toString()),
                  ),
                  infoWindow: InfoWindow(
                    title: workerProvider.listWorkers[index].firstName,
                  ),
                  icon: pinLocationIcon,
                );
              },
            );
          });
        }
      });
    });
  }

  bool flag=false;

  late Iterable markers;

  late Iterable<Marker> _markers = Set<Marker>();

  late List<Worker1> workerList;

  @override
  Widget build(BuildContext context) {
    print("WORKERS SCREEN");

    latLonProvider = Provider.of<LatLonProvider>(context);
    categoriesGridProvider = Provider.of<CategoriesGridProvider>(context);
    workerProvider = Provider.of<WorkerProvider>(context);
    workerLocationProvider = Provider.of<WorkerLocationProvider>(context);
    addCountProvider = Provider.of<AddCountProvider>(context);



    Future.delayed(Duration(seconds:2), () {
      flag = workerProvider.listWorkers.length==0;
    });
    setState(() {
      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
              "assets/images/worker_marker.png")
          .then((onValue) {
        pinLocationIcon = onValue;
      });
      markers = _markers;
    });

    return initial
        ?
    (flag?
    Scaffold( // No Worker Screen
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
      // endDrawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWorkerListMap(),
              _buildWorkerListNearestText(),
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317756/no_worker_iosvip.png", scale: 2.7),
                    ),
                    SizedBox(height: 10,),

                    Text(
                      'لا يوجد مزودي خدمة حتى الآن',
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

              ),
            ],
          ),
        ),
      ),
    ):
    Scaffold( // Shimmer screen
          body: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0,left: 5,right: 5),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF03ADD0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height/2,
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 14,
                                  width: 210,
                                  color: Colors.white,
                                ),
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8)),
                                Container(
                                  height: 10,
                                  width: 140,
                                  color: Colors.white,
                                )
                              ],
                            )),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
          )
              )):

    Scaffold( // Main screen
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
            // endDrawer: NavDrawer(),
            body: RefreshIndicator(
              onRefresh: () async =>
                  Provider.of<WorkerProvider>(context, listen: false)
                      .loadWorker(latLonProvider.lat, latLonProvider.longot,
                          categoriesGridProvider.categoryID.toString()),

              child: _buildWorkerScreen(),
            ),
          );
  }

  _buildWorkerScreen() {
    return Scaffold(
      backgroundColor: Color(0XFFF1F1F6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWorkerListMap(),
              _buildWorkerListNearestText(),
              _buildWorkerList()
            ],
          ),
        ),
      ),
    );
  }

  _buildWorkerListMap() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(latLonProvider.lat.toString()),
            double.parse(latLonProvider.longot.toString()),
          ),
          zoom: 12,
        ),
        markers: Set.from(markers),

        // on below line specifying map type.
        mapType: MapType.normal,
        // on below line setting user location enabled.
        myLocationEnabled: true,
        // on below line setting compass enabled.
        compassEnabled: true,

        // on below line specifying controller on map complete.
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

        circles: Set.from([
          Circle(
              circleId: CircleId(latLonProvider.lat.toString()),
              center: LatLng(
                double.parse(latLonProvider.lat.toString()),
                double.parse(latLonProvider.longot.toString()),
              ),
              radius: 5000,
              fillColor: Colors.blue.shade100.withOpacity(0.5),
              strokeColor: Colors.blue.shade600.withOpacity(0.5),
              strokeWidth: 2)
        ]),
        onCameraMove: null,
      ),
    );
  }

  _buildWorkerListNearestText() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF03ADD0),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          ": ترتيب الفنيين حسب المكان الأقرب اليك  ",
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  _buildWorkerList() {
    return Expanded(
      child: FutureBuilder(
        future: WorkerAPI().postWorkerRes(latLonProvider.lat,
            latLonProvider.longot, categoriesGridProvider.categoryID),
        builder: (context, AsyncSnapshot<List<Worker1>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading workers'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    markers = _markers;
                  } else {
                    return Center(
                      child: Text('No workers available'),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListTile(
                        onTap: () async {
                          addCountProvider.AddOneCount(snapshot.data![index].id.toString(), false);

                          Navigator.of(context).push(createRoute(WorkerDetails(worker: snapshot.data![index])));
                        },
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,left: 9.0),
                              child: GestureDetector(
                                onTap: (){

                                  addCountProvider.AddOneCount(snapshot.data![index].id.toString(), true);

                                  var pnum = snapshot.data![index].phone.toString();
                                  launch('tel:$pnum');
                                },
                                  child: Image.asset("assets/images/call.png", width: 45, height: 45)),
                            ),

                          ],
                        ),
                        trailing: Image.asset("assets/images/worker_image.png"),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                snapshot.data![index].firstName.toString() +
                                    " " +
                                    snapshot.data![index].lastName.toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0XFF6F6F6F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle:  Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("متر",
                              style: TextStyle(
                                color: Color(0XFF6F6F6F),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Cairo',
                              ),),
                            Text(
                              " ( " + snapshot.data![index].distance.toStringAsFixed(0)+ " ) " ,
                              style: TextStyle(
                                color: Color(0XFF6F6F6F),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(": يبعد عنك ",
                              style: TextStyle(
                                color: Color(0XFF6F6F6F),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Cairo',
                              ),),
                          ],
                        ),
                      ),

                      Divider(
                        thickness: 1,
                      )
                    ],
                  ); //                           <-- Divider
                });
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }
}
