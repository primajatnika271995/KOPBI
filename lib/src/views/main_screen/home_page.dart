import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/appVersionModel.dart';
import 'package:kopbi/src/services/angsuran.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/services/pinjaman.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  String _namaAnggota;
  String _IDAnggota;
  String _imgProfile;
  String _nik;

  ListSimpanan _listSimpanan;
  ListPinjaman _listPinjaman;

  int _totalAngsuran;

  String formattedTotalSimpanan;
  String formattedTotalPinjaman;

  var currentVersion;
  var oriBuildNumber = "13";

  var buildVersionBE;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            balanceField(),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  menuRow1(),
                  menuRow2(),
//              iklanField(),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 7.0),
            ],
          ),
          height: 100,
          child: bottomMenu(),
        ),
      ),
    );
  }

  Widget balanceField() {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.green,
          height: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        'Saldo Simpanan',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: '$formattedTotalSimpanan, - ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ]),
                      ),
                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(bottom: 5),
//                      child: RichText(
//                        text: TextSpan(children: <TextSpan>[
//                          TextSpan(
//                              text: 'SHU KOPBI',
//                              style: TextStyle(fontSize: 13)),
//                          TextSpan(
//                              text: ' 100, - ',
//                              style:
//                                  TextStyle(color: Colors.red, fontSize: 13)),
//                        ]),
//                      ),
//                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        'Saldo Pinjaman',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: ' ${formattedTotalPinjaman}, - ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 70, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: navSetting,
                      child: CircleAvatar(
                        backgroundImage: _imgProfile == null
                            ? AssetImage('assets/icons/no_user.jpg')
                            : NetworkImage(_imgProfile),
                        backgroundColor: Colors.green,
                        radius: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('Pengaturan Akun'),
                    ),
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  color: Colors.grey,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _namaAnggota == null
                            ? "NO DATA"
                            : '${_namaAnggota.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _IDAnggota == null ? "000" : '$_IDAnggota',
                        style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget menuRow1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/list-simpanan');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Simpanan.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Simpanan',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/pinjaman');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Pinjaman.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Pinjaman',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/konsumer');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Konsumer.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Konsumer',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/perumahan');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Perumahan.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Perumahan',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget menuRow2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/kredit');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Kredit.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Kredit',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/isi-ulang');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Isi-Ulang.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Isi ulang',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/tiket');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Tiket.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Tiket',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    Navigator.of(context).pushNamed('/lainnya');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Selengkapnya-01.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Prosedur',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(55),
          onTap: () => navMedia('http://kopbi.or.id'),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/website.png'),
              ),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(55),
          onTap: () => navMedia('https://www.instagram.com/kopbi.id/'),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/IG.png'),
              ),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(55),
          onTap: () => navMedia('https://twitter.com/kopbi1'),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/twitter.png'),
              ),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(55),
          onTap: () => navMedia(
              'https://www.youtube.com/channel/UCRRkWX-rXZDbH0gzxrpSWew'),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/youtube.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget iklanField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 150,
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  height: 150,
                  width: 270,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      image: DecorationImage(
                        image: NetworkImage(
                            'http://pinjamanringan.com/wp-content/uploads/2017/03/Pinjaman-Tunai-Cepat-Mudah-Bunga-Super-Ringan-Segera-Cair-di-Benowo-Surabaya.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  height: 150,
                  width: 270,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://i1.wp.com/www.tercanggih.com/wp-content/uploads/2019/04/Koperasi-Simpan-Pinjam-Pracico.jpg?fit=581%2C349'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUserDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _namaAnggota = _pref.getString(NAMA_ANGGOTA);
    _IDAnggota = _pref.getString(NOMOR_ANGGOTA);
    _imgProfile = _pref.getString(IMG_PROFILE);
    setState(() {});

    print(_imgProfile);
  }

  void navSetting() {
    Navigator.of(context).pushNamed('/settings');
  }

  void navMedia(String url) async {
    var _url = url;
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  String formattedNumber(dynamic number) {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(number);
  }


  void getDataSimpanan() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _nik = _pref.getString(NIK);
    _listSimpanan = ListSimpanan();
    _listPinjaman = ListPinjaman();
    _totalAngsuran = 0;

    formattedTotalSimpanan = _listSimpanan.formattedTotalSum;
    formattedTotalPinjaman = _listPinjaman.formattedTotal;

    print(_nik);

    _listSimpanan.getList(nik: _nik).then((_) {
      setState(() {
        formattedTotalSimpanan = _listSimpanan.formattedTotalSum;
        print(_listSimpanan.formattedTotalSum);
      });
    });

    _listPinjaman.getList(nik: _nik).then((_) {
      setState(() {
        formattedTotalPinjaman = formattedNumber(_listPinjaman.total - _totalAngsuran);
      });

      _listPinjaman.listPinjaman.forEach((pinjaman) {
        ListAngsuran listAnguran = ListAngsuran();
        listAnguran.getList(nomorPinjaman: pinjaman.nomorPinjaman).then((_) {
          setState(() {
            _totalAngsuran += listAnguran.totalPaid;
            formattedTotalPinjaman = formattedNumber(_listPinjaman.total - _totalAngsuran);
          });
        });
      });
    });

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
    ) ?? false;
  }


  @override
  void initState() {
    getUserDetails();
    getDataSimpanan();
//    getPackageName();
    getVersionBackend();
    super.initState();
  }

  void getVersionBackend() async {
    LoginProvider api = new LoginProvider();
    await api.appVersion().then((response) async {
      print(response.body);
      List<AppVersion> value = appVersionFromJson(response.body);
      print(value[0].nominal);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print("Aplikasi Version : $version");
      print("Aplikasi Build Number : $buildNumber");

      if (version != value[0].nominal) {
        updateApplicationDialog();
      }
    });
  }

//  void getPackageName() async {
//    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    String version = packageInfo.version;
//    String buildNumber = packageInfo.buildNumber;
//
//    print("Aplikasi Version : $version");
//    print("Aplikasi Build Number : $buildNumber");
//
//    if (buildNumber != oriBuildNumber) {
//      updateApplicationDialog();
//    }
//
//  }

  updateApplicationDialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          title: new Text("Aplikasi KOPBI Terbaru Telah Tersedia"),
          content: new Text("Pelanggan YTH, Kami telah melakukan pemutakhiran Aplikasi KOPBI."
              "\n\nSilahkan Install Aplikasi KOPBI terbaru untuk mendapatkan fitur terbaru dan pelayanan terbaik. Terimakasih"),
          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Nanti", style: TextStyle(color: Colors.grey[800]),),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                launch("https://play.google.com/store/apps/details?id=id.or.kopbi.solusi.mobile");
              },
            ),
          ],
        ),
      );
    });
  }


}
