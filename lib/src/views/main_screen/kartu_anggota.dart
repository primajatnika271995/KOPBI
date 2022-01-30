import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KartuAnggota extends StatefulWidget {
  @override
  _KartuAnggotaState createState() => _KartuAnggotaState();
}

class _KartuAnggotaState extends State<KartuAnggota> {
  String nama = 'admin';
  String idNumber = 'admin';
  String tglRegister = 'admin';
  String jenisKepesertaan = '';

  double totalWajib;

  GlobalKey globalKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    getDetails();
    getSaldoSimpanan();
    super.initState();
  }

  void getSaldoSimpanan() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);
    var noAnggota = _pref.getString(NOMOR_ANGGOTA);

    String url =
        "http://solusi.kopbi.or.id/api/kopbi-pinjaman/get-simpanan/$noAnggota";

    var uriResponse = await dio.post(url,
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    print("RESPONSE GET SALDO");
    print(uriResponse.statusCode);

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      print("VALUE");
      print(value.data);

      var parse = jsonDecode(value.data);

      SharedPreferences pref = await SharedPreferences.getInstance();

      totalWajib = double.parse(pref.getString(SIMPANAN_WAJIB));

      print(totalWajib);

      if (totalWajib >= 25000.0 && totalWajib <= 249999.0) {
        print("SILVER");
        jenisKepesertaan = "SILVER";
      } else if (totalWajib >= 250000.0 && totalWajib <= 2499999.0) {
        print("GOLD");
        jenisKepesertaan = "GOLD";
      } else if (totalWajib >= 2500000.0 && totalWajib <= 9999999.0) {
        print("PLATINUM");
        jenisKepesertaan = "PLATINUM";
      } else if (totalWajib >= 10000000.0) {
        print("TITANIUM");
        jenisKepesertaan = "TITANIUM";
      }

      setState(() {});
    }
  }

  void getDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      nama = _pref.getString(NAMA_ANGGOTA);
      idNumber = _pref.getString(NOMOR_ANGGOTA);
      tglRegister = _pref.getString(TGL_REGISTRASI);
    });
  }

  String formattedTanggalRegistrasi(tglRegsiter) {
    String formatted = tglRegsiter;

    if (tglRegsiter.contains(RegExp(r"^\d{4}\-\d{2}\-\d{2}"))) {
      List<String> split = tglRegsiter.split('-');

      List<String> months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];

      var bulan = int.parse(split[1]);

      formatted =
          "${split[2].substring(0, split[2].length - 13)}-${split[1]}-${split[0]}";
    }

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kartu Anggota',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            InkWell(
              onTap: _barCodePopUp,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Container(
                    width: 325.0,
                    height: 185.0,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          width: 350.0,
                          top: -62.0,
                          right: -210.0,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Image(
                                image:
                                    AssetImage('assets/icons/Logo-KOPBI.png')),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Container(
                                height: 50.0,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/icons/Logo-KOPBI.png'),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text("KARTU ANGGOTA",
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                            Container(
                                              color: Colors.green[900],
                                              width: 143,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Center(
                                                  child: Text(jenisKepesertaan,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontStyle:
                                                          FontStyle.normal),),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.0),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('$nama',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 2),
                                    Text('$idNumber'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.0),
                              Text(
                                  "Terdaftar Sejak ${formattedTanggalRegistrasi(tglRegister)}",
                                  style: TextStyle(fontSize: 11.0))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Syarat dan Ketentuan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("1."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text("Kartu ini adalah bukti keanggotaan"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("2."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Kartu ini tidak dapat digunakan oleh orang lain atau pihak lain selain Anggota bersangkutan"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("3."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Kartu ini berlaku untuk diskon di beberapa market yang sudah bekerjasama dengan KOPBI Indonesia"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("4."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Kartu ini tidak berlaku untuk pengambilan simpanan"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("5."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Pengambilan Simpanan Anggota wajib menyertakan buku anggota yang dapat diperoleh di kantor Sekretariat KOPBI Indonesia dan memenuhi segala Ketentuan berlaku"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("6."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Segala ketentuan berlaku sesuai dengan peraturan yang berlaku di KOPBI Indonesia"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah Anda yakin ingin keluar?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Tidak'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yakin'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future _barCodePopUp() {
    return showDialog(
      context: (context),
      builder: (_) => Dialog(
        child: Container(
          height: 300,
          width: 250,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 60),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: QrImage(
                        data: idNumber,
                        version: QrVersions.auto,
                        size: 170,
                        foregroundColor: Colors.black,
                        gapless: false,
                        errorStateBuilder: (cxt, err) {
                          return Container(
                            child: Center(
                              child: Text(
                                "Loading QR Code...",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
