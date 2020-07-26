import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:kopbi/src/app.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//  await FlutterDownloader.initialize();
  app();
}

checkAuthenticated() async {
  await Future.delayed(Duration(seconds: 2));
  return true;
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


  void onMessageFCM() {
    print("ON Message FMC");

    _firebaseMessaging.subscribeToTopic("kopbi-notifikasi");

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(message);
      return displayNotification(message);
    }, onResume: (Map<String, dynamic> message) {
      print(message);
      return displayNotification(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print(message);
      return displayNotification(message);
    });

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token : $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: Image.asset('assets/icons/Logo-KOPBI.png', scale: 13.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: <Widget>[
                Text(
                  "from",
                  style: TextStyle(
                    letterSpacing: 0.7,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "KEMNAKER RI",
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future displayNotification(Map<String, dynamic> message) async {
    print("show notification");

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'id.or.kopbi.solusi.mobile', 'KOPBI Notification', 'KOPBI',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker', );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


  @override
  void initState() {
    onMessageFCM();

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    checkAuthenticated().then((_) async {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var nomorAnggota = _pref.getString(NOMOR_ANGGOTA);

      if (nomorAnggota == null) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        Navigator.of(context).pushReplacementNamed('/re-login');
      }
    });
    super.initState();
  }
}
