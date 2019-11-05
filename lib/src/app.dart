import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopbi/main.dart';
import 'package:kopbi/src/views/login_screen/login_page.dart';
import 'package:kopbi/src/views/main_screen/main_page.dart';
import 'package:kopbi/src/views/register_screen/register_page.dart';
import 'package:kopbi/src/views/setting_screen/setting_page.dart';

void app() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainScreen(),
        '/settings': (context) => SettingScreen(),
      },
    ),
  );
}
