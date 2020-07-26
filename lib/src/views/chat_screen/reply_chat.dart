import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/time_ago_service.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/more_screen/details_laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReplyChatView extends StatefulWidget {
  final MessageLaporan value;
  final int idContent;
  ReplyChatView({this.value, this.idContent});

  @override
  _ReplyChatViewState createState() => _ReplyChatViewState();
}

class _ReplyChatViewState extends State<ReplyChatView> {
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var dio = Dio();

  var msgReplyCtrl = new TextEditingController();

  List<MessageReplyLaporan> listReply = [];
  bool isLoadReply = false;

  String username;
  String noAnggota;
  String noNik;
  String kodePerusahaan;
  String namaPerusahaan;

  void getPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString(NAMA_ANGGOTA);
    noAnggota = pref.getString(NOMOR_ANGGOTA);
    noNik = pref.getString(NIK);
    kodePerusahaan = pref.getString(KODE_PERUSAHAAN);
    namaPerusahaan = pref.getString(NAMA_PERUSAHAAN);
  }

  void refreshReply(int idReply) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url = "http://solusi.kopbi.or.id:8889/kopbi-master/list-komentar";

    var uriResponse = await dio.post(url,
        data: {
          "contentId": widget.idContent,
          "balasId": idReply,
        },
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);
      setState(() {
        listReply.add(MessageReplyLaporan(
          id: m.last["id"],
          nama: m.last["nama"],
          komentar: m.last["komentar"],
          nomorAnggota: m.last["nomorAnggota"],
          createdDate: m.last["createdDate"],
          namaPerusahaan: m.last["namaPerusahaan"],
        ));
      });
    }
  }

  void getReplyKomentar(int idReply) async {
    print("get Reply");
    listReply = [];
    setState(() {
      isLoadReply = true;
    });

    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url = "http://solusi.kopbi.or.id:8889/kopbi-master/list-komentar";

    var uriResponse = await dio.post(url,
        data: {
          "contentId": widget.idContent,
          "balasId": idReply,
        },
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);
      for (Map<String, dynamic> item in m) {
        print("add reply");
        setState(() {
          listReply.add(MessageReplyLaporan(
            id: item["id"],
            nama: item["nama"],
            komentar: item["komentar"],
            nomorAnggota: item["nomorAnggota"],
            createdDate: item["createdDate"],
            namaPerusahaan: item["namaPerusahaan"],
          ));
        });
      }

      setState(() {
        isLoadReply = false;
      });
    }
  }

  void onSendReply() async {
    print("id yg di Reply : ${widget.value.id}");

    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url = "http://solusi.kopbi.or.id:8889/kopbi-master/post-komentar";

    var uriResponse = await dio.post(url,
        data: {
          "contentId": widget.idContent,
          "namaKonten": widget.value.komentar,
          "nomorAnggota": noAnggota,
          "nama": username,
          "nomorNik": noNik,
          "kodePerusahaan": kodePerusahaan,
          "namaPerusahaan": namaPerusahaan,
          "komentar": msgReplyCtrl.text,
          "balasId": widget.value.id,
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
            content: Text("Balasan telah terkirim."),
            behavior: SnackBarBehavior.floating,
          ),
        );
        msgReplyCtrl.clear();
        refreshReply(widget.value.id);
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getReplyKomentar(widget.value.id);
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "Replies to"),
                          TextSpan(
                            text: " ${widget.value.nama}'s",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: " comment on this"),
                          TextSpan(
                            text: " post",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ]),
                  ),
                ),
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(
                                    "http://solusi.kopbi.or.id:8889/kobi-images/anggota/${widget.value.nomorAnggota}.jpg"),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "${widget.value.nama}",
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
                                      "${TimeAgoService().timeAgoFormatting(widget.value.createdDate)}",
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
                                  "${widget.value.namaPerusahaan}",
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
                              "${widget.value.komentar}",
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 0.7,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  isLoadReply
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                      : listReply.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        "Belum ada balasan",
                        style: TextStyle(
                          letterSpacing: 0.7,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemBuilder: (context, index) {
                      return commentReplyContent(listReply[index]);
                    },
                    itemCount: listReply.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: messageTypeContent(),
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
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
              padding: const EdgeInsets.only(right: 10, top: 10, left: 10, bottom: 10),
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
                  controller: msgReplyCtrl,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                    hintText: "Tulis balasan ...",
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
                  onSendReply();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
