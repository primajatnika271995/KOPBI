import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kopbi/src/app.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      body: Center(
        child: Image.asset('assets/icons/Logo-KOPBI.png', scale: 20.0),
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
