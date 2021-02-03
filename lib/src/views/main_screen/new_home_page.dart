import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/models/appVersionModel.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/angsuran.dart';
import 'package:kopbi/src/services/barangApi.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/services/pinjaman.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/info_covid_screen/info_covid.dart';
import 'package:kopbi/src/views/kredit_screen/pengajuan_kredit_from_home.dart';
import 'package:kopbi/src/views/main_screen/catatan.dart';
import 'package:kopbi/src/views/main_screen/detail_info_catatan.dart';
import 'package:kopbi/src/views/main_screen/details_info.dart';
import 'package:kopbi/src/views/main_screen/details_info_iklan.dart';
import 'package:kopbi/src/views/main_screen/event.dart';
import 'package:kopbi/src/views/main_screen/grid_kredit_barang.dart';
import 'package:kopbi/src/views/main_screen/iklan2.dart';
import 'package:kopbi/src/views/main_screen/info.dart';
import 'package:kopbi/src/views/setting_screen/ubah_data_anggota.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage>
    with TickerProviderStateMixin {
  static List<String> imgKeterangan = [];
  static List<String> imgList = [];
  static List<String> iklanKeteranganList = [];

  static List<String> kegiatanList = [];
  static List<String> kegiatanKeterangan = [];

  static List<String> informasiList = [];
  static List<String> informasiKeterangan = [];

  static List<String> iklanList = [];
  static List<String> iklanKeterangan = [];

  AnimationController _ColorAnimationController;
  AnimationController _TextAnimationController;
  Animation _colorTween, _iconColorTween;
  Animation<Offset> _transTween;
  bool completiondata;

  ListBarang _dbBarang;
  List<Barang> _listBarang;

  var hargaBarang = new NumberFormat.currency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  List<Widget> dummy = [
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];

  GlobalKey<ScaffoldState> _scaffoldKey;
  PanelController panelController = new PanelController();
  AnimationController sliderTransformController;
  Animation<double> sliderTransformAnimation;

  var _isVisible;

  ScrollController _scrollController;

  bool sliderShow = false;

  final sliderPosition = new ValueNotifier(0.0);

  String _namaAnggota;
  String _IDAnggota;
  String imgProfile;
  String _nik;
  String _status;

  ListSimpanan _listSimpanan;
  ListPinjaman _listPinjaman;

  List<String> listGambarKredit = [];

  int _totalAngsuran;

  String formattedTotalSimpanan;
  String formattedTotalSimpananNew = "0";
  String formattedTotalPinjaman;

  var currentVersion;
  var oriBuildNumber = "13";

  var buildVersionBE;

  int _current = 0;

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

  void getUserDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _namaAnggota = _pref.getString(NAMA_ANGGOTA);
    _IDAnggota = _pref.getString(NOMOR_ANGGOTA);
    imgProfile = _pref.getString(IMG_PROFILE);
    _status = _pref.get(STATUS_ANGGOTA);
    completiondata = _pref.getBool(COMPLETIONDATA);

    if (_status == "A") {
      _status = "Aktif";
    } else if (_status == "I") {
      _status = "Non Akfif";
    } else {
      _status = "Baru";
    }

    setState(() {});

    print("INI IMAGE PROFILE :" + imgProfile);
  }

  void navSetting() {
    Navigator.of(context).pushNamed('/settings');
  }

  void navInformasi() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InfoTabs(),
      ),
    );
  }

  void navKegiatan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventTabs(),
      ),
    );
  }

  void navCatatan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CatatanTabs(),
      ),
    );
  }

  void navIklan2() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Iklan2Tabs(),
      ),
    );
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
    _nik = _pref.getString(NOMOR_ANGGOTA);
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
      print("TOTAL PINJAMAN");
      // setState(() {
      //   formattedTotalPinjaman =
      //       formattedNumber(_listPinjaman.total - _totalAngsuran);
      //
      //   print("TOTAL PINJAMAN");
      //   print(formattedTotalPinjaman);
      // });

      _listPinjaman.listPinjaman.forEach((pinjaman) {
        ListAngsuran listAnguran = ListAngsuran();
        listAnguran.getList(nomorPinjaman: pinjaman.nomorPinjaman).then((_) {
          setState(() {
            _totalAngsuran += listAnguran.totalPaid;
            formattedTotalPinjaman =
                formattedNumber(_listPinjaman.total - _totalAngsuran);
            print(formattedTotalPinjaman);
          });
        });
      });
    });
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

  void onNavigationUbahDataAnggota() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => UbahDataAnggotaScreen(),
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

      formattedTotalSimpananNew = formattedNumber(parse["totalSimpanan"]);
      setState(() {});
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

  void getInformasi() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url =
        "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/informasi";

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
          informasiList.add(item["id"].toString());
          informasiKeterangan.add(item["keterangan"].toString());
        });
      }
    }
  }

  void getIklan1() async {
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

  void getIklan() async {
    var dio = Dio();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    String url =
        "http://solusi.kopbi.or.id:8889/kopbi-master/list-konten/iklan2";

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
          iklanList.add(item["id"].toString());
          iklanKeterangan.add(item["keterangan"].toString());
        });
      }
    }
  }

  void show() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool isShow = pref.getBool(SHOW_IKLAN);

    if (isShow) {
      showIklan();
    }
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
                                  keterangan: iklanKeteranganList[0] == null ||
                                          iklanKeteranganList[0].isEmpty
                                      ? "Tidak ada Keterangan."
                                      : iklanKeteranganList[0],
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
                                    color: Colors.black, size: 25),
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

  void onHide() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool(SHOW_IKLAN, false);
    });

    Navigator.of(context).pop();
  }

  Dio _dio;

  void getGambarKredit(String gambarId) async {
    var uriResponse = await _dio
        .get("http://solusi.kopbi.or.id:8889/kobi-images/barang/gambarId.jpg");

    print(uriResponse.statusCode);
    if (uriResponse.statusCode == 200) {
      setState(() {
        listGambarKredit.add(
            "http://solusi.kopbi.or.id:8889/kobi-images/barang/gambarId.jpg");
      });
    } else {
      setState(() {
        listGambarKredit.add(
            "https://ideas.or.id/wp-content/themes/consultix/images/no-image-found-360x250.png");
      });
    }
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);

      _TextAnimationController.animateTo(
          (scrollInfo.metrics.pixels - 350) / 50);
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    show();
    getSaldoSimpanan();
    getCatatan();
    getImgKtp();
    getKegiatan();
    getInformasi();
    getUserDetails();
    getCatatan();
    getIklan();
    getIklan1();
    getDataSimpanan();
    getVersionBackend();
    imageCache.clear();

    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.green)
        .animate(_ColorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.grey, end: Colors.white)
        .animate(_ColorAnimationController);

    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_TextAnimationController);

    _listBarang = [];
    _dbBarang = ListBarang();

    _dbBarang.getList().then((_) {
      switch (_) {
        case HttpStatus.success:
          _listBarang = _dbBarang.listBarang
              .where((f) => f.stokBarang >= 1 && f.kategori == 'barang')
              .toList().reversed.toList();

          print("STOCK : $_listBarang");
          print("List Barang Sukses");

          break;
        case HttpStatus.error:
          print("List Barang Error");
          break;
        case HttpStatus.serverError:
          print("List Barang Server Error");
          break;
        case HttpStatus.noInternet:
          print("List Barang No Internet");
          break;
      }
    });

    _isVisible = true;
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Container(
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    catatanContent(),
                    balanceField(),
                    Platform.isAndroid ? Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 40, right: 40),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                    ) : Container(),
                    completiondata ? Container() : Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Data anda belum lengkap, segera lengkapi data anda",
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
                                onNavigationUbahDataAnggota();
                              },
                              color: Colors.red,
                              child: Text(
                                "UPDATE",
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
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Sosial Media",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        bottomMenu(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Iklan",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  navIklan2();
                                },
                                child: Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 170,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailsInfoScreen(
                                          url:
                                              "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${iklanList[index]}.jpg",
                                          keterangan: iklanKeterangan.reversed
                                              .toList()[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${iklanList[index]}.jpg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    height: 170,
                                    width: 300,
                                  ),
                                ),
                              );
                            },
                            itemCount:
                                iklanList.length <= 3 ? iklanList.length : 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Kredit Barang",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          GridKreditBarang()));
                                },
                                child: Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            height: 190,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
//                            getGambarKredit(_listBarang[index].kodeBarang);

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 2,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PengajuanKreditFromHome(
                                              data: _listBarang[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 190,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ClipRRect(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "http://solusi.kopbi.or.id:8889/kobi-images/barang/${_listBarang[index].kodeBarang}.jpg",
                                                width: 130,
                                                height: 100,
                                                fit: BoxFit.contain,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.network(
                                                  "http://solusi.kopbi.or.id:8889/kobi-images/barang/default.jpg",
                                                  fit: BoxFit.fitWidth,
                                                  height: 100,
                                                  width: 130,
                                                ),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            Divider(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 5,
                                                right: 5,
                                                bottom: 3,
                                              ),
                                              child: Text(
                                                "${_listBarang[index].namaBarang}",
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 5,
                                                right: 5,
                                                bottom: 3,
                                              ),
                                              child: Text(
                                                "${hargaBarang.format(_listBarang[index].harga * 10)}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _listBarang.length > 3
                                  ? 3
                                  : _listBarang.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Kegiatan",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  navKegiatan();
                                },
                                child: Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 170,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailsInfoScreen(
                                          url:
                                              "http://solusi.kopbi.or.id:8889/kobi-images/kegiatan/${kegiatanList.reversed.toList()[index]}.jpg",
                                          keterangan: kegiatanKeterangan
                                              .reversed
                                              .toList()[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "http://solusi.kopbi.or.id:8889/kobi-images/kegiatan/${kegiatanList.reversed.toList()[index]}.jpg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    height: 170,
                                    width: 300,
                                  ),
                                ),
                              );
                            },
                            itemCount: kegiatanList.reversed.toList().length < 3
                                ? kegiatanList.reversed.toList().length
                                : 3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Informasi",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  navInformasi();
                                },
                                child: Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 170,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailsInfoScreen(
                                          url:
                                              "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${informasiList.reversed.toList()[index]}.jpg",
                                          keterangan: informasiKeterangan
                                              .reversed
                                              .toList()[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${informasiList.reversed.toList()[index]}.jpg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    height: 170,
                                    width: 300,
                                  ),
                                ),
                              );
                            },
                            itemCount:
                                informasiList.reversed.toList().length < 3
                                    ? informasiList.reversed.toList().length
                                    : 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: AnimatedBuilder(
                  animation: _ColorAnimationController,
                  builder: (context, child) => AppBar(
                    backgroundColor: _colorTween.value,
                    elevation: 0,
                    title: Text(
                      'KOPBI Solution',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          navSetting();
                        },
                        icon: Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget catatanContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        image: DecorationImage(
          image: AssetImage('assets/logo/home-bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            CarouselSlider.builder(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              reverse: true,
              height: 100,
              enableInfiniteScroll: true,
              aspectRatio: 2.0,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print(imgKeterangan[index]);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailsInfoIklanScreen(
                          url:
                              "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${imgList[index]}.png",
                          keterangan: imgKeterangan[index] == null ||
                                  imgKeterangan[index].isEmpty
                              ? "Tidak ada Keterangan."
                              : imgKeterangan[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Image.network(
                      "http://solusi.kopbi.or.id:8889/kobi-images/informasi/${imgList[index]}.png",
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                  ),
                );
              },
              itemCount: imgList.length,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dummy.map((e) {
                          int index = dummy.indexOf(e);
                          return Container(
                            width: 10.0,
                            height: 10.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colors.green
                                    : Colors.grey[200]),
                          );
                        }).toList()),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        navCatatan();
                      },
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
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
                              text: '$formattedTotalSimpananNew, - ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ]),
                      ),
                    ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      ),
                      Text(
                        _status == null ? "-" : '$_status',
                        style: TextStyle(fontSize: 17, color: Colors.grey[600], fontWeight: FontWeight.bold),
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

  Widget slidingSheetBuilder() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        sliderPosition,
        sliderTransformController,
      ]),
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, sliderTransformAnimation.value),
          child: slidingPanel(),
        );
      },
    );
  }

  Widget slidingPanel() {
    double margin = 24 * (-sliderPosition.value + 1);
    double marginFooter = sliderPosition.value * 48;
    double border = 50 * (-sliderPosition.value + 1);
    double footerOpacity() {
      if (sliderPosition.value == 0)
        return 1.0;
      else if (sliderPosition.value <= .20) {
        return 1 - (sliderPosition.value * 4);
      } else
        return 0.0;
    }

    return SlidingUpPanel(
      controller: panelController,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          spreadRadius: 2,
          blurRadius: 12,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
      header: Container(
        width: MediaQuery.of(context).size.width - 48 + marginFooter,
        height: 12,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 35,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ),
      footer: Opacity(
        opacity: footerOpacity(),
        child: Center(
          child: Container(
            height: 85,
            padding: EdgeInsets.symmetric(horizontal: 12),
            width: MediaQuery.of(context).size.width - 48 + marginFooter,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.green[600],
                            ),
                            child: Align(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(55),
                                onTap: () => navMedia(
                                    'https://www.instagram.com/kopbi.id/'),
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
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green[600],
                          ),
                          child: Align(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(55),
                              onTap: () =>
                                  navMedia('https://twitter.com/kopbi1'),
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/icons/twitter.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Twitter',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red,
                          ),
                          child: InkWell(
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
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Youtube',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red,
                          ),
                          child: InkWell(
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
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Website',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(border),
        bottomRight: Radius.circular(border),
      ),
      margin: EdgeInsets.all(margin),
      backdropColor: Colors.black45,
      backdropEnabled: false,
      maxHeight: 95,
      minHeight: 95,
      panelBuilder: (scrollController) {
        return SizedBox();
      },
    );
  }

  Widget bottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Website',
                style: TextStyle(fontSize: 13),
              ),
            )
          ],
        ),
        Column(
          children: <Widget>[
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Instagram',
                style: TextStyle(fontSize: 13),
              ),
            )
          ],
        ),
        Column(
          children: <Widget>[
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Twitter',
                style: TextStyle(fontSize: 13),
              ),
            )
          ],
        ),
        Column(
          children: <Widget>[
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Youtube',
                style: TextStyle(fontSize: 13),
              ),
            )
          ],
        ),
      ],
    );
  }
}
