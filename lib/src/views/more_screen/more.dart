import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/laporan.dart';
import 'package:kopbi/src/views/more_screen/details_laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  List<LaporanModel> listLaporan = [];

  bool isLoading = false;

  void getLaporan() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences _pref = await SharedPreferences.getInstance();
    var jwtToken = _pref.getString(JWT_TOKEN);

    Dio _dio = new Dio();
    Response response = await _dio.post(
      "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/laporan",
      options: Options(
        headers: {
          'jwtToken': jwtToken,
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
        },
      ),
    );

    MessageModel value = messageModelFromJson(json.encode(response.data));
    List<dynamic> m = json.decode(value.data);

    if (response.statusCode == 200) {
      m.forEach((url) {
        print(url["id"]);
        setState(() {
          listLaporan.add(LaporanModel(
              id: url["id"],
              keterangan: url["keterangan"],
              namaKonten: url["namaKonten"],
              imgUrl:
                  "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${url["id"]}.jpg",
              pdfUrl:
                  "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${url["id"]}.pdf"));
        });
      });

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getLaporan();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0,
        backgroundColor: Colors.green,
        title: Text(
          'Laporan',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: isLoading
            ? Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Center(
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset.fromDirection(20.0),
                              blurRadius: 5.0,
                              spreadRadius: -3.0)
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Container(
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.black12,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black12)),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 180.0,
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.black12,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black12)),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 180.0,
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.black12,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : listLaporan.length < 1
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 -
                            MediaQuery.of(context).padding.top),
                    child: Center(
                      child: Text(
                        'Tidak ada Laporan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsLaporanView(
                                    id: listLaporan[index].id.toString(),
                                    urlImg: listLaporan[index].imgUrl,
                                    urlPdf: listLaporan[index].pdfUrl,
                                    namaKonten: listLaporan[index].namaKonten,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset.fromDirection(20.0),
                                        blurRadius: 5.0,
                                        spreadRadius: -3.0)
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(listLaporan[index].imgUrl),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: listLaporan.length,
                  ),
      ),
    );
  }
}

class LaporanModel {
  final int id;
  final String namaKonten;
  final String imgUrl;
  final String pdfUrl;
  final String keterangan;

  LaporanModel(
      {this.id, this.namaKonten, this.imgUrl, this.pdfUrl, this.keterangan});
}
