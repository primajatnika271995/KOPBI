import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: Image.asset('assets/icons/Logo-KOPBI.png', scale: 20.0),
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
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
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
