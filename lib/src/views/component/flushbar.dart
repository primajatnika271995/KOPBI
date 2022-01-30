import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Widget flushBar(BuildContext context, String title, int duration) {
  return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.all(8.0),
    borderRadius: 8.0,
    message: title,
    leftBarIndicatorColor: Colors.redAccent,
    duration: Duration(seconds: duration),
  )..show(context);
}
