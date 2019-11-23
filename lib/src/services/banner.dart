import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show join;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

class BannerItem {
  String _url;
  String get url => _url;

  BannerItem({
    String url
  }) {
    _url = url;
  }
}

class MyBanner extends StatefulWidget {
  MyBanner({Key key, @required this.title}) : super(key: key);

  String title;

  @override
  _MyBannerState createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  GlobalKey<AnimatedListState> _listKey;

  List<String> _listBannerUrl;

  List<String> _listEvent = [
    "http://solusi.kopbi.or.id/api/kobi-images/kegiatan/5.jpg",
    "http://solusi.kopbi.or.id/api/kobi-images/kegiatan/6.jpg",
    "http://solusi.kopbi.or.id/api/kobi-images/kegiatan/7.jpg",
    "http://solusi.kopbi.or.id/api/kobi-images/kegiatan/8.jpg",
    "http://solusi.kopbi.or.id/api/kobi-images/kegiatan/9.jpg"
  ];

  ScrollController _scrollController;

  Timer task;
  Timer taskShowBanner;

  Directory _dir;

  bool isPerformingRequest;

  var client;

  @override
  // TODO: implement widget
  MyBanner get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isPerformingRequest = false;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });

    _listKey = new GlobalKey<AnimatedListState>();

    _listBannerUrl = [
      null,
      null,
      null,
    ];

    client = new http.Client();

    switch (widget.title.toLowerCase()) {
      case 'informasi':
        task = Timer(Duration(seconds: 1), () async {
          try {
            String url = "https://aksarabiner.id/kopbi_banner/?q=informasi";

            var uriResponse = await client.get(url);

            List<dynamic> m = jsonDecode(uriResponse.body);

            _listBannerUrl = [];

            setState(() {
              clearBanner();

              m.forEach((url) {
                _listBannerUrl.add(url);
              });

              showBanner();
            });
          } catch (ie) {
            print('Error detail');
            print(ie);
            print('End error detail');
          }
        });
        break;
      case 'event':
        task = Timer(Duration(seconds: 1), () async {
          try {
            String url = "https://aksarabiner.id/kopbi_banner/?q=kegiatan";

            var uriResponse = await client.get(url);

            List<dynamic> m = jsonDecode(uriResponse.body);

            _listBannerUrl = [];

            setState(() {
              clearBanner();

              _listBannerUrl.add("http://solusi.kopbi.or.id/api/kobi-images/kegiatan/5.jpg");
              _listBannerUrl.add("http://solusi.kopbi.or.id/api/kobi-images/kegiatan/6.jpg");
              _listBannerUrl.add("http://solusi.kopbi.or.id/api/kobi-images/kegiatan/7.jpg");
              _listBannerUrl.add("http://solusi.kopbi.or.id/api/kobi-images/kegiatan/8.jpg");
              _listBannerUrl.add("http://solusi.kopbi.or.id/api/kobi-images/kegiatan/9.jpg");

              showBanner();
            });
          } catch (ie) {
            print('Error detail');
            print(ie);
            print('End error detail');
          }
        });
        break;
    }

    getTemporaryDirectory().then((dir) {
      setState(() {
        _dir = dir;
      });
    });
  }

  @override
  void dispose() {
    if(task != null) {
      task.cancel();
    }

    if(taskShowBanner != null) {
      taskShowBanner.cancel();
    }

    if(_scrollController != null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void clearBanner() {
    for (var i = 0; i < _listBannerUrl.length; i++) {
      _listKey.currentState.removeItem(0, (BuildContext context, Animation<double> animation) {
        return ScaleTransition(
            scale: animation,
            child: bannerPlaceholder(height: 170.0)
        );
      });
    }
    _listBannerUrl.clear();
  }

  void showBanner() {
    taskShowBanner = Timer(Duration(milliseconds: 500), () {
      for (var i = 0; i < _listBannerUrl.length; i++) {
        int duration = (200 * ((i + 1) / 2)).round();
        if(duration > 500) duration = 200;

        _listKey.currentState.insertItem(i, duration: Duration(milliseconds: duration));
      }
    });
  }

  Widget _makeElement(int index, Animation animation) {
    if(index >= _listBannerUrl.length) {
      return null;
    }

    return ScaleTransition(
      scale: animation,
      child: bannerPlaceholder(height: 170.0, url: _listBannerUrl[index]),
    );
  }

  _getMoreData() async {
    if(!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });

      switch (widget.title.toLowerCase()) {
        case 'informasi':
          try {
            Map<String, dynamic> params = {
              'q': 'informasi',
              'p': json.encode(_listBannerUrl),
            };

            String url = "https://aksarabiner.id/kopbi_banner/";

            http.Response uriResponse = await client.post(url,
                headers: {
                  'Content-Type': 'application/json'
                },
                body: json.encode(params)
            );

            List<dynamic> m = jsonDecode(uriResponse.body);

            m.forEach((url) {
              if(_listBannerUrl.indexOf(url) < 0) {
                setState(() {
                  _listBannerUrl.add(url);
                  _listKey.currentState.insertItem(_listBannerUrl.indexOf(_listBannerUrl.last), duration: Duration(milliseconds: 200));
                });
              }
            });
          } catch (ie) {
            print('Error detail');
            print(ie);
            print('End error detail');
          }
          break;
        case 'event':
          try {
            Map<String, dynamic> params = {
              'q': 'kegiatan',
              'p': json.encode(_listBannerUrl),
            };

            String url = "https://aksarabiner.id/kopbi_banner/";

            http.Response uriResponse = await client.post(url,
                headers: {
                  'Content-Type': 'application/json'
                },
                body: json.encode(params)
            );

            List<dynamic> m = jsonDecode(uriResponse.body);

            m.forEach((url) {
              if(_listBannerUrl.indexOf(url) < 0) {
                setState(() {
                  _listBannerUrl.add(url);
                  _listKey.currentState.insertItem(_listBannerUrl.indexOf(_listBannerUrl.last), duration: Duration(milliseconds: 200));
                });
              }
            });
          } catch (ie) {
            print('Error detail');
            print(ie);
            print('End error detail');
          }
          break;
      }

      setState(() {
        isPerformingRequest = false;
      });
    }
  }

  Future<void> writeToFile(ByteData data, String filename) {
    final path = join(_dir.path, filename);
    final buffer = data.buffer;
    return new File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Widget cacheBanner(String url) {
    var urlBytes = utf8.encode(url);
    var urlDigest = md5.convert(urlBytes);
    var path = join(_dir.path, urlDigest.toString());
    File file = File(path);

    bool fileExists = file.existsSync();

    if(fileExists) {
      //print("(From file) $url");
      return Image.file(file, fit: BoxFit.cover);
    }

    //print("(From http) $url");
    return FutureBuilder(
      future: http.get(url),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: LinearProgressIndicator(backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: LinearProgressIndicator(backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: LinearProgressIndicator(backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
              ],
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Container(
                  width: 170.0,
                  child: Center(
                      child: Text('Error')
                  )
              );
            }

            var buffer = snapshot.data.bodyBytes.buffer;
            ByteData bytes = ByteData.view(buffer);

            writeToFile(bytes, urlDigest.toString());

            return Image.memory(snapshot.data.bodyBytes, fit: BoxFit.cover);
        }
        return null; // unreachable
      },
    );
  }

  Widget _bannerContent(String url) {
    if(url == null || _dir == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Container(
            width: 180.0,
            child: LinearProgressIndicator(backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 180.0,
            child: LinearProgressIndicator(backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 180.0,
            child: LinearProgressIndicator(backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: cacheBanner(url),
    );
  }

  Widget bannerPlaceholder({double height, double width, Function callback, String url}) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, bottom: 10),
      child: Container(
        height: height,
        padding: url != null ? EdgeInsets.all(0.0) : EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [BoxShadow(offset: Offset.fromDirection(20.0), blurRadius: 5.0, spreadRadius: -3.0)]
        ),
        child: _bannerContent(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(10.0),
      initialItemCount: _listBannerUrl.length,
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index, Animation animation) => _makeElement(index, animation),
    );
  }
}