import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/appVersionModel.dart';
import 'package:kopbi/src/models/catatanModel.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/angsuran.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/services/pinjaman.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:kopbi/src/views/info_covid_screen/info_covid.dart';
import 'package:kopbi/src/views/main_screen/detail_info_catatan.dart';
import 'package:kopbi/src/views/main_screen/details_info.dart';
import 'package:kopbi/src/views/main_screen/details_info_iklan.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  String _namaAnggota;
  String _IDAnggota;
  String imgProfile;
  String _nik;

  ListSimpanan _listSimpanan;
  ListPinjaman _listPinjaman;

  int _totalAngsuran;

  String formattedTotalSimpanan;
  String formattedTotalPinjaman;

  var currentVersion;
  var oriBuildNumber = "13";

  var buildVersionBE;

  static List<String> imgList = [];
  static List<String> imgKeterangan = [];
  static List<String> iklanKeteranganList = [];

  static List<String> kegiatanList = [];
  static List<String> kegiatanKeterangan = [];

  static List<String> infoList = [];
  static List<String> infoKeterangan = [];

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  void onNavigationInfoCovid() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CovidInfoScreen(),
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

  void showIklan() {
    return WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showGeneralDialog(
          barrierColor: Colors.grey.withOpacity(0.5),
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          transitionDuration: Duration(milliseconds: 1000),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Container(
                    width: 50,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailsInfoCatatanScreen(
                                  keterangan: iklanKeteranganList[0] == null || iklanKeteranganList[0].isEmpty ? "Tidak ada Keterangan." : iklanKeteranganList[0],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "http://solusi.kopbi.or.id:8889/kobi-images/informasi/36.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              onHide();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10000),
                              ),
                              child: Center(
                                child: Icon(Icons.close,
                                    color: Colors.black, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          pageBuilder: (context, animation1, animation2) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              balanceField(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              "assets/icons/info-covid.png",
                              height: 30,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Covid-19 Info",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Info harian terbaru virus Corona!",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: RaisedButton(
                        onPressed: () {
                          onNavigationInfoCovid();
                        },
                        color: Colors.red,
                        child: Text(
                          "VIEW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              menuRow1(),
              menuRow2(),
              CarouselSlider.builder(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                autoPlayCurve: Curves.bounceIn,
                reverse: false,
                height: 100,
                enableInfiniteScroll: true,
                aspectRatio: 2.0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print(imgKeterangan[index]);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailsInfoIklanScreen(
                            url: "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${imgList[index]}.png",
                            keterangan: imgKeterangan[index] == null || imgKeterangan[index].isEmpty ? "Tidak ada Keterangan." : imgKeterangan[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(children: <Widget>[
                          Image.network(
                              "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${imgList[index]}.png",
                              fit: BoxFit.cover,
                              width: 1000.0),
                        ]),
                      ),
                    ),
                  );
                },
                itemCount: imgList.length,
              ),
              SizedBox(height: 100),
            ],
          ),
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

  final List child = map<Widget>(
    imgList,
    (index, i) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(children: <Widget>[
              Image.network(
                  "http://solusi.kopbi.or.id:8889/kobi-images/informasi/$i.png",
                  fit: BoxFit.cover,
                  width: 1000.0),
            ]),
          ),
        ),
      );
    },
  ).toList();

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
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundImage: imgProfile == null
                            ? AssetImage('assets/icons/no_user.jpg')
                            : NetworkImage(imgProfile),
                        backgroundColor: Colors.green,
                        radius: 25,
                      ),
                    ),
//                    Padding(
//                      padding: const EdgeInsets.symmetric(vertical: 2),
//                      child: Text('Pengaturan Akun'),
//                    ),
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
                  'Penarikan',
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
                    Navigator.of(context).pushNamed('/tiket');
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/kredit_motor.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Kendaraan',
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
//          Column(
//            children: <Widget>[
//              Material(
//                child: InkWell(
//                  borderRadius: BorderRadius.circular(1000),
//                  onTap: () {
//                    Navigator.of(context).pushNamed('/tiket');
//                  },
//                  child: Container(
//                    height: 55,
//                    width: 55,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                        image: AssetImage('assets/icons/Tiket.png'),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 10),
//                child: Text(
//                  'Tiket',
//                  style: TextStyle(fontSize: 13),
//                ),
//              )
//            ],
//          ),
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
                  'Laporan',
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
    imgProfile = _pref.getString(IMG_PROFILE);

    setState(() {});

    print("INI IMAGE PROFILE :" + imgProfile);
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
    var f = new NumberFormat.currency(
        locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
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
        formattedTotalPinjaman =
            formattedNumber(_listPinjaman.total - _totalAngsuran);
      });

      _listPinjaman.listPinjaman.forEach((pinjaman) {
        ListAngsuran listAnguran = ListAngsuran();
        listAnguran.getList(nomorPinjaman: pinjaman.nomorPinjaman).then((_) {
          setState(() {
            _totalAngsuran += listAnguran.totalPaid;
            formattedTotalPinjaman =
                formattedNumber(_listPinjaman.total - _totalAngsuran);
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
        ) ??
        false;
  }

  void onHide() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool(SHOW_IKLAN, false);
    });

    Navigator.of(context).pop();
  }

  void show() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool isShow = pref.getBool(SHOW_IKLAN);

    if (isShow) {
      showIklan();
    }
  }

  @override
  void initState() {
    show();
    getImgKtp();
    getUserDetails();
    getCatatan();
    getIklan();
    getDataSimpanan();
    getVersionBackend();

    imageCache.clear();
    super.initState();
  }

  void getVersionBackend() async {
    LoginProvider api = new LoginProvider();
    await api.appVersion().then((response) async {
      MessageModel value = messageModelFromJson(json.encode(response.data));
      List<AppVersion> data = appVersionFromJson(value.data);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print("Aplikasi Version : $version");
      print("Aplikasi Build Number : $buildNumber");
      print("BE Version : ${data[0].nominal}");

      if (version != data[0].nominal) {
        updateApplicationDialog();
      }
    });
  }

  updateApplicationDialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          title: new Text("Aplikasi KOPBI Terbaru Telah Tersedia"),
          content: new Text(
              "Pelanggan YTH, Kami telah melakukan pemutakhiran Aplikasi KOPBI."
              "\n\nSilahkan Install Aplikasi KOPBI terbaru untuk mendapatkan fitur terbaru dan pelayanan terbaik. Terimakasih"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                launch(
                    "https://play.google.com/store/apps/details?id=id.or.kopbi.solusi.mobile");
              },
            ),
          ],
        ),
      );
    });
  }

  void getImgKtp() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);
    var noKtp = _pref.getString(NO_KTP);

    String url = "http://solusi.kopbi.or.id:8889/kobi-images/ktp/$noKtp.jpg";

    var response = await dio.get(url,
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (response.statusCode == 200) {
      setState(() {
        _pref.setString(IMG_KTP,
            "http://solusi.kopbi.or.id:8889/kobi-images/ktp/$noKtp.jpg");
      });
    }
  }

  void getIklan() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url =
        "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/iklan";

    var uriResponse = await dio.post(url,
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);
      for (Map<String, dynamic> item in m) {
        print(item["namaKonten"]);
        setState(() {
          iklanKeteranganList.add(item["keterangan"].toString());
        });
      }
    }
  }

  void getCatatan() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url =
        "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/catatan";

    var uriResponse = await dio.post(url,
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);
      for (Map<String, dynamic> item in m) {
        print(item["keterangan"]);
        setState(() {
          imgList.add(item["id"].toString());
          imgKeterangan.add(item["keterangan"].toString());
        });
      }
    }
  }

  void getKegiatan() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url =
        "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/kegiatan";

    var uriResponse = await dio.post(url,
        options: Options(headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }));

    if (uriResponse.statusCode == 200) {
      MessageModel value = messageModelFromJson(json.encode(uriResponse.data));

      List<dynamic> m = jsonDecode(value.data);
      for (Map<String, dynamic> item in m) {
        print(item["keterangan"]);
        setState(() {
          kegiatanList.add(item["id"].toString());
          kegiatanKeterangan.add(item["keterangan"].toString());
        });
      }
    }
  }
}
