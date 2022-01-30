import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class KetentuanKebijakanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://www.kopbi.or.id/ketentuan-kebijakan/',
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Ketentuan dan Kebijakan',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      clearCache: true,
      clearCookies: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
