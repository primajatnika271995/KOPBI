import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/time_ago_service.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/chat_screen/reply_chat.dart';
import 'package:kopbi/src/views/more_screen/details_laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsChatView extends StatefulWidget {
  @override
  _DetailsChatViewState createState() => _DetailsChatViewState();
}

class _DetailsChatViewState extends State<DetailsChatView> {
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  var msgInputCtrl = new TextEditingController();
  var msgReplyCtrl = new TextEditingController();

  DateFormat dateFormat = new DateFormat("yyy-MM-dd hh:mm");

  String username;
  String noAnggota;
  String noNik;
  String kodePerusahaan;
  String namaPerusahaan;

  String role;

  bool isLoadKomentar = false;
  bool isLoadReply = false;

  List<MessageLaporan> listMsg = [];
  List<MessageReplyLaporan> listReply = [];

  var dio = Dio();

  void getPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString(NAMA_ANGGOTA);
    noAnggota = pref.getString(NOMOR_ANGGOTA);
    noNik = pref.getString(NIK);
    kodePerusahaan = pref.getString(KODE_PERUSAHAAN);
    namaPerusahaan = pref.getString(NAMA_PERUSAHAAN);
    role = pref.getString(ROLE);

    print(role);
  }

  void getKomentar() async {
    setState(() {
      isLoadKomentar = true;
    });
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
        if (role == "AGT") {
          setState(() {
            if (item["nomorAnggota"] == noAnggota) {
              listMsg.add(MessageLaporan(
                id: item["id"],
                nama: item["nama"],
                komentar: item["komentar"],
                nomorAnggota: item["nomorAnggota"],
                createdDate: item["createdDate"],
                namaPerusahaan: item["namaPerusahaan"],
                updatedDate: item["updatedDate"] == null ? DateTime.parse("2018-01-15T00:00:00.000") : DateTime.parse(item["updatedDate"]),
                balasan: item["balasan"],
              ));
            }
          });
        }

        if (role == "ADM") {
          setState(() {
            listMsg.add(MessageLaporan(
              id: item["id"],
              nama: item["nama"],
              komentar: item["komentar"],
              nomorAnggota: item["nomorAnggota"],
              createdDate: item["createdDate"],
              namaPerusahaan: item["namaPerusahaan"],
              balasan: item["balasan"],
            ));
          });
        }
      }

      setState(() {
        isLoadKomentar = false;
      });
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

      print(value.data);
      setState(() {
        listMsg.add(MessageLaporan(
          id: m.last["id"],
          nama: m.last["nama"],
          komentar: m.last["komentar"],
          nomorAnggota: m.last["nomorAnggota"],
          createdDate: m.last["createdDate"],
          namaPerusahaan: m.last["namaPerusahaan"],
          balasan: m.last["balasan"],
        ));
      });
    }
  }

  void onSendComment() async {
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
          "komentar": msgInputCtrl.text,
          "balasId": 0,
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
            content: Text("Komentar telah terkirim."),
            behavior: SnackBarBehavior.floating,
          ),
        );
        msgInputCtrl.clear();
        refreshKomentar();
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPreferences();
    getKomentar();
    super.initState();
  }

  void onNavReply(MessageLaporan value) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ReplyChatView(
          value: value,
          idContent: 1,
        ),
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: isLoadKomentar
          ? Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      )
          : listMsg.isEmpty
          ? Center(
        child: Text(
          "Belum ada Pertanyaan",
          style: TextStyle(
            letterSpacing: 0.7,
            fontSize: 14,
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
             ListView.builder(
              itemBuilder: (context, index) {
//                print(listMsg[index].updatedDate);
                listMsg.sort((a, b) => a.updatedDate.compareTo(DateTime.now()));
                print(listMsg[index].updatedDate);
                return commentContent(listMsg[index]);
              },
              itemCount: listMsg.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
      bottomNavigationBar: messageTypeContent(),
    );
  }

  Widget commentContent(MessageLaporan value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(
                      "http://solusi.kopbi.or.id:8889/kobi-images/anggota/${value.nomorAnggota}.jpg"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "${value.nama}",
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("•"),
                      ),
                      Text(
                        "${TimeAgoService().timeAgoFormatting(value.createdDate)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "${value.namaPerusahaan}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: screenWidth(context),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${value.komentar}",
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 0.7,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              onNavReply(value);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.message,
                  size: 15,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("•"),
                ),
                Text(
                  " ${value.balasan} Replies",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget commentReplyContent(MessageReplyLaporan value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            "http://solusi.kopbi.or.id:8889/kobi-images/anggota/${value.nomorAnggota}.jpg"),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${value.nama}",
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "${TimeAgoService().timeAgoFormatting(value.createdDate)}",
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${value.komentar}",
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 0.7,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget messageTypeContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  right: 10, top: 10, left: 10, bottom: 10),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    "http://solusi.kopbi.or.id:8889/kobi-images/anggota/$noAnggota.jpg"),
              ),
            ),
            Flexible(
              child: Container(
                height: 20,
                child: TextField(
                  controller: msgInputCtrl,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Tulis Pertanyaan ...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.lightGreen,
                onPressed: () {
                  onSendComment();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}