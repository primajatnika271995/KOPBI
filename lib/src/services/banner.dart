import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/views/main_screen/detail_info_catatan.dart';
import 'package:kopbi/src/views/main_screen/details_info.dart';
import 'package:kopbi/src/views/main_screen/details_info_iklan.dart';
import 'package:path/path.dart' show join;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerItem {
  String _url;
  String get url => _url;

  BannerItem({String url}) {
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

  List<String> _listBannerUrl = [];
  List<String> _listBannerKeterangan = [];

  ScrollController _scrollController;

  Timer task;
  Timer taskShowBanner;

  Directory _dir;
  String jwtToken;

  bool isPerformingRequest;

  var client;

  Dio _dio = new Dio();

  @override
  // TODO: implement widget
  MyBanner get widget => super.widget;

  void getToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = _pref.getString(JWT_TOKEN);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken();

    isPerformingRequest = false;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
      }
    });

    _listKey = new GlobalKey<AnimatedListState>();

    _listBannerUrl = [
      null,
      null,
      null,
    ];

    _listBannerKeterangan = [
      null,
      null,
      null,
    ];

    client = new http.Client();

    switch (widget.title.toLowerCase()) {
      case 'informasi':
        task = Timer(Duration(seconds: 1), () async {
          try {
            _listBannerUrl = [];
            _listBannerKeterangan = [];

            Response response = await _dio.post(
              "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/informasi",
              options: Options(
                headers: {
                  'jwtToken': jwtToken,
                  'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
                },
              ),
            );

            MessageModel value = messageModelFromJson(json.encode(response.data));
            print(value.data);

            List<dynamic> m = json.decode(value.data);

            m.reversed.forEach((url) {
              print(url["id"]);
              setState(() {
                _listBannerUrl.add(
                    "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${url['id']}.jpg");
                _listBannerKeterangan.add("${url['keterangan']}");
                showBanner();
              });
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
            _listBannerUrl = [];
            _listBannerKeterangan = [];

            Response response = await _dio.post(
              "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/kegiatan",
              options: Options(
                headers: {
                  'jwtToken': jwtToken,
                  'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
                },
              ),
            );

            MessageModel value =
                messageModelFromJson(json.encode(response.data));
            print(value.data);

            List<dynamic> m = json.decode(value.data);

            m.reversed.forEach((url) {
              print(url["id"]);
              setState(() {
                _listBannerUrl.add(
                    "http://solusi.kopbi.or.id:8889/kobi-images/kegiatan/${url['id']}.jpg");
                _listBannerKeterangan.add("${url['keterangan']}");
                showBanner();
              });
            });
          } catch (ie) {
            print('Error detail');
            print(ie);
            print('End error detail');
          }
        });
        break;
      case 'catatan':
        task = Timer(Duration(seconds: 1), () async {
          try {
            _listBannerUrl = [];
            _listBannerKeterangan = [];

            Response response = await _dio.post(
              "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/catatan",
              options: Options(
                headers: {
                  'jwtToken': jwtToken,
                  'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
                },
              ),
            );

            MessageModel value =
            messageModelFromJson(json.encode(response.data));
            print(value.data);

            List<dynamic> m = json.decode(value.data);

            m.reversed.forEach((url) {
              print(url["id"]);
              setState(() {
                _listBannerUrl.add(
                    "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${url['id']}.png");
                _listBannerKeterangan.add("${url['keterangan']}");
                showBanner();
              });
            });
          } catch (ie) {
            print('Error detail');
            print(ie);
            print('End error detail');
          }
        });
        break;
      case 'iklan2':
        task = Timer(Duration(seconds: 1), () async {
          try {
            _listBannerUrl = [];
            _listBannerKeterangan = [];

            Response response = await _dio.post(
              "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/iklan2",
              options: Options(
                headers: {
                  'jwtToken': jwtToken,
                  'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
                },
              ),
            );

            MessageModel value =
            messageModelFromJson(json.encode(response.data));
            print(value.data);

            List<dynamic> m = json.decode(value.data);

            m.reversed.forEach((url) {
              print(url["id"]);
              setState(() {
                _listBannerUrl.add(
                    "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${url['id']}.jpg");
                _listBannerKeterangan.add("${url['keterangan']}");
                showBanner();
              });
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
    if (task != null) {
      task.cancel();
    }

    if (taskShowBanner != null) {
      taskShowBanner.cancel();
    }

    if (_scrollController != null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void clearBanner() {
    for (var i = 0; i < _listBannerUrl.length; i++) {
      _listKey.currentState.removeItem(0,
          (BuildContext context, Animation<double> animation) {
        return ScaleTransition(
            scale: animation, child: bannerPlaceholder(height: 170.0));
      });
    }
    _listBannerUrl.clear();
  }

  void showBanner() {
    taskShowBanner = Timer(Duration(milliseconds: 500), () {
      for (var i = 0; i < _listBannerUrl.length; i++) {
        int duration = (200 * ((i + 1) / 2)).round();
        if (duration > 500) duration = 200;

        _listKey.currentState
            .insertItem(i, duration: Duration(milliseconds: duration));
      }
    });
  }

  Widget _makeElement(int index, Animation animation) {
    if (index >= _listBannerUrl.length) {
      return null;
    }

    return ScaleTransition(
      scale: animation,
      child: bannerPlaceholder(height: 170.0, url: _listBannerUrl[index], keterangan: _listBannerKeterangan[index]),
    );
  }

  Future<void> writeToFile(ByteData data, String filename) {
    final path = join(_dir.path, filename);
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Widget cacheBanner(String url) {
    var urlBytes = utf8.encode(url);
    var urlDigest = md5.convert(urlBytes);
    var path = join(_dir.path, urlDigest.toString());
    File file = File(path);

    bool fileExists = file.existsSync();

    if (fileExists) {
      //print("(From file) $url");
      if (widget.title.toLowerCase() == "catatan") {
        return Image.file(file, fit: BoxFit.contain);
      }
      return Image.file(file, fit: BoxFit.fill);
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
                  child: LinearProgressIndicator(
                      backgroundColor: Colors.black12,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: LinearProgressIndicator(
                      backgroundColor: Colors.black12,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: LinearProgressIndicator(
                      backgroundColor: Colors.black12,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.black12)),
                ),
              ],
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Container(
                  width: 170.0, child: Center(child: Text('Error')));
            }

            var buffer = snapshot.data.bodyBytes.buffer;
            ByteData bytes = ByteData.view(buffer);

            writeToFile(bytes, urlDigest.toString());

            return Image.memory(snapshot.data.bodyBytes, fit: BoxFit.fill);
        }
        return null; // unreachable
      },
    );
  }

  Widget _bannerContent(String url, String keterangan) {
    if (url == null || _dir == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Container(
            width: 180.0,
            child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 180.0,
            child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 180.0,
            child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        onTap: () {
          if (widget.title.toLowerCase() == 'catatan') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailsInfoIklanScreen(
                  url: url,
                  keterangan: keterangan,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailsInfoScreen(
                  url: url,
                  keterangan: keterangan,
                ),
              ),
            );
          }
        },
        child: cacheBanner(url),
      ),
    );
  }

  Widget bannerPlaceholder(
      {double height, double width, Function callback, String url, String keterangan}) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, bottom: 10),
      child: Container(
        height: height,
        padding: url != null ? EdgeInsets.all(0.0) : EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(20.0),
                  blurRadius: 5.0,
                  spreadRadius: -3.0)
            ]),
        child: _bannerContent(url, keterangan),
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
      itemBuilder: (BuildContext context, int index, Animation animation) =>
          _makeElement(index, animation),
    );
  }
}
