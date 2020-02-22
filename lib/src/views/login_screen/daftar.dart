import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class DaftarScreen extends StatefulWidget {
  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          title: Text(
            'Daftar',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      body: Container(
          child: Column(children: <Widget>[
            Expanded(
              child: Container(
                child: InAppWebView(
                    initialUrl: "https://www.kopbi.or.id/formulir-pendaftaran-menjadi-anggota-kopbi/",
                    initialHeaders: {},
                    initialOptions: InAppWebViewWidgetOptions(
                      inAppWebViewOptions: InAppWebViewOptions(
                        mediaPlaybackRequiresUserGesture: false,
                        debuggingEnabled: true,
                      ),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {

                    },
                    onLoadStop: (InAppWebViewController controller, String url) {

                    },
                    onPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                      print(origin);
                      print(resources);
                      return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                    }
                ),
              ),
            ),
          ]))
    );
    return WebviewScaffold(
      url: 'http://kopbi.or.id/formulir-pendaftaran-menjadi-anggota-kopbi/',
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Daftar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      withLocalUrl: true,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      withOverviewMode: true,
      clearCache: true,
      clearCookies: true,
      allowFileURLs: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
