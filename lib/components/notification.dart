
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;

  NotificationItem({required this.title, required this.body, required this.time});
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [];
  bool _isLoading = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Future<void> _deleteItem(int index) async {
  //   setState(() {
  //     stringList.removeAt(index);
  //     prefs.setStringList('stringList', stringList);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    _firebaseMessaging.getToken().then((token) {
      print('Token: $token');
    });
    loadNotifications();
  }
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Handling background message: ${message.notification?.title}');
    // If the notification screen is currently open, force a refresh to display the new notification
    if (mounted) {
      await _refreshNotifications();
    }
  }

  Future<void> loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notificationTitles = prefs.getStringList('notificationTitles');
    List<String>? notificationBodies = prefs.getStringList('notificationBodies');
    List<String>? notificationTimestamps = prefs.getStringList('notificationTimestamps');
    if (notificationTitles != null && notificationBodies != null) {
      setState(() {
        notifications = List.generate(notificationTitles.length, (index) {
          return NotificationItem(
            title: notificationTitles[index],
            body: notificationBodies[index],
            time: notificationTimestamps![index],
          );
        });
      });
    }
  }

  Future<void> _refreshNotifications() async {

    setState(() {
      notifications.clear();
      _isLoading = true;
    });
     loadNotifications();
    setState(() {
      _isLoading = false;
    });
  }

  bool _onNotificationScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.atEdge && !_isLoading) {
        _refreshNotifications();
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0XFFF1F1F6),
      // Color(0XFFF1F1F6),
      appBar: AppBar(
        title: Text(
          "الإشعارات",
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
      body: notifications.length ==0?
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: NotificationListener<ScrollNotification>(
          onNotification: _onNotificationScrollNotification,
          child: RefreshIndicator(
            onRefresh: _refreshNotifications,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Column(
                    children: [
                      Center(
                        child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317657/no_notification_lspk4d.png",),
                      ),
                      SizedBox(height: 20,),

                      Text(
                        'لم تتلقى إشعارات حتى الآن',
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
      )
          :SizedBox(
    width: double.infinity,
    child: Padding(
    padding:
    EdgeInsets.symmetric(horizontal: 8),

        child: NotificationListener<ScrollNotification>(
          onNotification: _onNotificationScrollNotification,
          child: RefreshIndicator(
            onRefresh: _refreshNotifications,
            child: ListView.builder(
              itemCount: notifications.length + 1,
              itemBuilder: (context, index) {
                if (index < notifications.length) {
                  return buildCustomCard(
                    notifications[index].title,
                    notifications[index].body,
                    notifications[index].time,
                    index,
                  );
                } else {
                  return _buildLoadMoreIndicator();
                }
              },
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget buildCustomCard(String title, String subtitle, String time, int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double paddingValue = screenWidth * 0.035; // Adjust this multiplier according to your preference

        return Padding(
          padding: EdgeInsets.only(left: paddingValue, right: paddingValue, bottom: paddingValue),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: Card(
              color: Colors.white,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 5, right: 10,left: 10),
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: GestureDetector(
                        onTap: () {
                          _deleteNotification(index);
                        },
                        child: Icon(Icons.delete_forever, size: 35,color: Colors.redAccent,),
                      ),
                    ),
                    trailing:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317757/s_logo_iu1vov.png"),
                    ),

                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        maxLines: 3, // Adjust as needed
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.right,
                        maxLines: 3, // Adjust as needed
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 1.4, // Adjust height as needed
                      child: Container(
                        color: Color(0xFF03ADD0), // Adjust color as needed
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 8),
                    child: Text(
                      time,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0XFF888888),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
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

  Future<void> _deleteNotification(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> notificationTitles = prefs.getStringList('notificationTitles') ?? [];
    List<String> notificationBodies = prefs.getStringList('notificationBodies') ?? [];
    List<String> notificationTimestamps = prefs.getStringList('notificationTimestamps') ?? [];

    notificationTitles.removeAt(index);
    notificationBodies.removeAt(index);
    notificationTimestamps.removeAt(index);

    await prefs.setStringList('notificationTitles', notificationTitles);
    await prefs.setStringList('notificationBodies', notificationBodies);
    await prefs.setStringList('notificationTimestamps', notificationTimestamps);

    // Reload notifications after deletion
    await loadNotifications();
  }




  Widget _buildLoadMoreIndicator() {
    return _isLoading
        ? Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    )
        : Container();
  }
}
