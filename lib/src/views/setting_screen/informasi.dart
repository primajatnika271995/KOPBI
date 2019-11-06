import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class InformasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://kopbi.or.id/profile-kopbi/',
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Tentang KOPBI Indonesia',
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
