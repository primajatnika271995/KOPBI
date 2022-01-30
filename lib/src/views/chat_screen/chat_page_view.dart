import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/views/chat_screen/received_message_widget.dart';
import 'package:kopbi/src/views/chat_screen/sended_message_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPageView extends StatefulWidget {
  final String username;

  const ChatPageView({
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var dio = Dio();
  
  var timeFormat = new DateFormat('hh:mm');

  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  var childList = <Widget>[];

  String username;
  String noAnggota;
  String noNik;
  String kodePerusahaan;
  String namaPerusahaan;

  void getKomentar() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url = "http://solusi.kopbi.or.id:8889/kopbi-master/list-komentar";

    var uriResponse = await dio.post(url,
        data: {
          "contentId": 1,
          "balasId": 0,
        },
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);
      for (Map<String, dynamic> item in m) {
        setState(() {
          if (item["nomorAnggota"] == noAnggota) {
            childList.add(Align(
              alignment: Alignment(1, 0),
              child: SendedMessageWidget(
                content: item["komentar"],
                time: item["createdDate"],
              ),
            ));
          }

          if (item["nomorAnggota"] == "11") {
            childList.add(Align(
              alignment: Alignment(-1, 0),
              child: ReceivedMessageWidget(
                content: item["komentar"],
                time: item["createdDate"],
              ),
            ));
          }
        });
      }
    }
  }

  void getPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString(NAMA_ANGGOTA);
    noAnggota = pref.getString(NOMOR_ANGGOTA);
    noNik = pref.getString(NIK);
    kodePerusahaan = pref.getString(KODE_PERUSAHAAN);
    namaPerusahaan = pref.getString(NAMA_PERUSAHAAN);
  }

  void onSendChat() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url = "http://solusi.kopbi.or.id:8889/kopbi-master/post-komentar";

    var uriResponse = await dio.post(url,
        data: {
          "contentId": 1,
          "namaKonten": "Chat Admin",
          "nomorAnggota": noAnggota,
          "nama": username,
          "nomorNik": noNik,
          "kodePerusahaan": kodePerusahaan,
          "namaPerusahaan": namaPerusahaan,
          "komentar": _text.text,
          "balasId": int.parse(noAnggota),
        },
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    print(uriResponse.data);

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      if (value.success) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Pesan telah terkirim."),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _text.clear();
        refreshKomentar();
        return;
      }
    }
  }

  void refreshKomentar() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url = "http://solusi.kopbi.or.id:8889/kopbi-master/list-komentar";

    var uriResponse = await dio.post(url,
        data: {
          "contentId": 1,
          "balasId": 0,
        },
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);

      setState(() {
        childList.add(Align(
          alignment: Alignment(1, 0),
          child: SendedMessageWidget(
            content: m.last["komentar"],
            time: m.last["createdDate"],
          ),
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    getKomentar();
//    childList.add(Align(
//        alignment: Alignment(0, 0),
//        child: Container(
//          margin: const EdgeInsets.only(top: 5.0),
//          height: 25,
//          width: 50,
//          decoration: BoxDecoration(
//              color: Colors.black12,
//              borderRadius: BorderRadius.all(
//                Radius.circular(8.0),
//              )),
//          child: Center(
//              child: Text(
//                "Today",
//                style: TextStyle(fontSize: 11),
//              )),
//        )));
//    childList.add(Align(
//      alignment: Alignment(1, 0),
//      child: SendedMessageWidget(
//        content: 'Hello',
//        time: '21:36 PM',
//      ),
//    ));
//    childList.add(Align(
//      alignment: Alignment(1, 0),
//      child: SendedMessageWidget(
//        content: 'How are you? What are you doing?',
//        time: '21:36 PM',
//      ),
//    ));
//    childList.add(Align(
//      alignment: Alignment(-1, 0),
//      child: ReceivedMessageWidget(
//        content: 'Hello, Mohammad.I am fine. How are you?',
//        time: '22:40 PM',
//      ),
//    ));
//    childList.add(Align(
//      alignment: Alignment(1, 0),
//      child: SendedMessageWidget(
//        content:
//        'I am good. Can you do something for me? I need your help my bro.',
//        time: '22:40 PM',
//      ),
//    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    child: Container(
                      color: Colors.green,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.username ?? "Admin KOPBI",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text(
                                "online",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Container(
                              child: ClipRRect(
                                child: Container(
                                    child: Image.asset(
                                      "assets/logo/kopbi-logo.png",
                                      fit: BoxFit.fill,
                                    ),
                                    color: Colors.white),
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(0.0),
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        spreadRadius: -1,
                                        offset: Offset(0.0, 5.0))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    // height: 500,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/logo/chat-background-1.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.linearToSrgbGamma()),
                      ),
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          // reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: childList,
                          )),
                    ),
                  ),
                  Divider(height: 0, color: Colors.black26),
                  // SizedBox(
                  //   height: 50,
                  Container(
                    color: Colors.white,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        maxLines: 20,
                        controller: _text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              onSendChat();
                            },
                          ),
                          border: InputBorder.none,
                          hintText: "Tulis pesan ...",
                        ),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
