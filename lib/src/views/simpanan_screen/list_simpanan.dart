import 'dart:async';

import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:kopbi/src/views/component/transition/fade_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpananListPage extends StatefulWidget {
  @override
  _SimpananListPageState createState() => _SimpananListPageState();
}

class _SimpananListPageState extends State<SimpananListPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey;
  GlobalKey<AnimatedListState> _listKey;

  Animation totalPokokAnim;
  Animation totalWajibAnim;
  Animation totalSukarelaAnim;
  AnimationController totalAnimController;

  double _tabActivePos;
  PageController _tabController;

  Timer timer;

  ListSimpanan _dbSimpanan;

  List<Simpanan> _listSimpanan;
  Map<String, bool> _listSimpananActive;

  bool isLoading;

  String nik;
  String namaAnggota;
  String namaJabatan = "Anggota";
  String imgUrl;

  @override
  // TODO: implement widget
  SimpananListPage get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = false;

    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _listKey = new GlobalKey<AnimatedListState>();

    _listSimpanan = [];
    _listSimpananActive = {};
    getUserDetails();

    _dbSimpanan = ListSimpanan();

    totalAnimController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    _tabActivePos = 0.0;
    _tabController = PageController();
    _tabController.addListener(() {
      setState(() {
        _tabActivePos = _tabController.page * 13.0;
      });
    });

    getListSimpanan();
  }

  void getUserDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    namaAnggota = _pref.getString(NAMA_ANGGOTA);
    imgUrl = _pref.getString(IMG_PROFILE);
    setState(() {});
  }

  void getListSimpanan() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      nik = _pref.getString(NIK);
    });

    _dbSimpanan.getList(nik: nik).then((_) {
      switch (_) {
        case HttpStatus.success:
          setState(() {
            _listSimpanan = _dbSimpanan.listSimpanan.where((i) => i.kodeSimpanan.toLowerCase() == 'spw').toList();

            _listSimpanan.sort((a, b) {
              String tglTglA = a.tanggalSimpanan.day.toString();
              String tglBlnA = a.tanggalSimpanan.month.toString();
              String tglThnA = a.tanggalSimpanan.year.toString();
              String tglHourA = a.tanggalSimpanan.hour.toString();
              String tglMinuteA = a.tanggalSimpanan.minute.toString();
              String tglSecondA = a.tanggalSimpanan.second.toString();

              if (tglTglA.length == 1) {
                tglTglA = "0$tglTglA";
              }
              if (tglBlnA.length == 1) {
                tglBlnA = "0$tglBlnA";
              }
              if (tglHourA.length == 1) {
                tglHourA = "0$tglHourA";
              }
              if (tglMinuteA.length == 1) {
                tglMinuteA = "0$tglMinuteA";
              }
              if (tglSecondA.length == 1) {
                tglSecondA = "0$tglSecondA";
              }

              String tglTglB = b.tanggalSimpanan.day.toString();
              String tglBlnB = b.tanggalSimpanan.month.toString();
              String tglThnB = b.tanggalSimpanan.year.toString();
              String tglHourB = b.tanggalSimpanan.hour.toString();
              String tglMinuteB = b.tanggalSimpanan.minute.toString();
              String tglSecondB = b.tanggalSimpanan.second.toString();

              if (tglTglB.length == 1) {
                tglTglB = "0$tglTglB";
              }
              if (tglBlnB.length == 1) {
                tglBlnB = "0$tglBlnB";
              }
              if (tglHourB.length == 1) {
                tglHourB = "0$tglHourB";
              }
              if (tglMinuteB.length == 1) {
                tglMinuteB = "0$tglMinuteB";
              }
              if (tglSecondB.length == 1) {
                tglSecondB = "0$tglSecondB";
              }

              int tglA = int.parse(
                  "$tglThnA$tglBlnA$tglTglA$tglHourA$tglMinuteA$tglSecondA");
              int tglB = int.parse(
                  "$tglThnB$tglBlnB$tglTglB$tglHourB$tglMinuteB$tglSecondB");

              return tglB.compareTo(tglA);
            });

            _listSimpananActive = {};

            _listSimpanan.forEach((_) {
              setState(() {
                _listSimpananActive[_.idSimpanan] = false;
              });
            });

            showData();
          });
          print("List Simpanan Sukses");
          break;
        case HttpStatus.error:
          print("List Simpanan Error");
          break;
        case HttpStatus.serverError:
          print("List Simpanan Server Error");
          break;
        case HttpStatus.noInternet:
          print("List Simpanan No Internet");
          break;
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  String formatCurrency(int number) {
    var f = new NumberFormat.currency(
        locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(number);
  }

  void showData() {
    totalPokokAnim = IntTween(begin: 0, end: _dbSimpanan.totalPokok).animate(
        CurvedAnimation(
            parent: totalAnimController, curve: Curves.easeInOutSine));
    totalWajibAnim = IntTween(begin: 0, end: _dbSimpanan.totalWajib).animate(
        CurvedAnimation(
            parent: totalAnimController, curve: Curves.easeInOutSine));
    totalSukarelaAnim = IntTween(begin: 0, end: _dbSimpanan.totalSukarela)
        .animate(CurvedAnimation(
            parent: totalAnimController, curve: Curves.easeInOutSine));

    totalAnimController.forward();

    timer = Timer(Duration(milliseconds: 100), () {
      for (var i = 0; i < _listSimpanan.length; i++) {
        int duration = (200 * ((i + 1) / 2)).round();
        if (duration > 1000) duration = 200;

        _listKey.currentState
            .insertItem(i, duration: Duration(milliseconds: duration));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer != null) {
      timer.cancel();
    }
    totalAnimController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String dateFormat(DateTime dateTime) {
    if (dateTime == null) return '';

    String date = dateTime.day.toString();

    if (date.length == 1) date = "0$date";

    List<String> months = [
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

    return date +
        ' ' +
        months[(dateTime.month - 1)] +
        ' ' +
        dateTime.year.toString();
  }

  Widget _buildItem(Simpanan simpanan, int index) {
    Color jenisColor;
    Color jenisShadowColor;

    switch (simpanan.jenisIuran.toLowerCase()) {
      case 'penarikan':
        jenisColor = Colors.red;
        jenisShadowColor = Color.fromARGB(100, 255, 116, 0);
        break;
      default:
        jenisColor = Colors.white;
        jenisShadowColor = Color.fromARGB(100, 6, 245, 175);
        break;
    }

    return Container(
      color: jenisColor,
      child: ListTile(
        title: Text(
          simpanan.jenisIuran.toLowerCase() == 'penarikan'
              ? simpanan.keterangan
              : simpanan.namaSimpanan,
          style: TextStyle(
            color: simpanan.jenisIuran.toLowerCase() == 'penarikan'
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text(
              dateFormat(simpanan.tanggalSimpanan).substring(3, dateFormat(simpanan.tanggalSimpanan).length),
              style: TextStyle(
                color: simpanan.jenisIuran.toLowerCase() == 'penarikan'
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              dateFormat(simpanan.tanggalSimpanan),
              style: TextStyle(
                color: simpanan.jenisIuran.toLowerCase() == 'penarikan'
                    ? Colors.white
                    : Colors.grey,
                  fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Text(
          simpanan.formattedNominalSimpanan,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: simpanan.jenisIuran.toLowerCase() == 'penarikan'
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 360.0, height: 640.0)
      ..init(context);

    Widget tabIndicator({int index, bool active}) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 3.0),
        width: 7.0,
        height: 7.0,
        decoration: BoxDecoration(
            color: active == true ? Colors.white70 : Colors.transparent,
            border: Border.all(color: Colors.white70),
            borderRadius: BorderRadius.circular(5.0)),
      );
    }

    return AnimatedBuilder(
      animation: totalAnimController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
//            backgroundColorStart: Color.fromARGB(190, 153, 255, 51),
//            backgroundColorEnd: Color.fromARGB(255, 51, 153, 153),
            backgroundColor: Colors.green,
            centerTitle: true,
            title: Text("Simpanan", style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Parent(
                  style: userCardStyle,
                  child: Column(
                    children: <Widget>[
                      _buildUserRow(),
                      SizedBox(height: 10),
                      _buildUserStats(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: _listSimpanan.length == 0
                ? Center(
                    child: isLoading == true
                        ? CircularProgressIndicator()
                        : Text(
                            'Tidak ada simpanan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black45,
                            ),
                          ),
                  )
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: 0,
                    itemBuilder:
                        (BuildContext context, int index, Animation animation) {
                      Simpanan simpanan = _listSimpanan[index];
                      return ScaleTransition(
                        scale: animation,
                        child: _buildItem(simpanan, index),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        Parent(
          style: userImageStyle,
          child: CircleAvatar(
            backgroundImage: imgUrl == null
                ? AssetImage('assets/icons/no_user.jpg')
                : NetworkImage(imgUrl),
            backgroundColor: Colors.green,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              namaAnggota == null ? 'Admin' : namaAnggota,
              style: nameTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              namaJabatan,
              style: nameDescriptionTextStyle,
            )
          ],
        )
      ],
    );
  }

  Widget _buildUserStats() {
    return Parent(
      style: userStatsStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildUserStatsItem(
              totalPokokAnim != null
                  ? formatCurrency(totalPokokAnim.value)
                  : formatCurrency(0),
              'Simpanan Pokok'),
          _buildUserStatsItem(
              totalWajibAnim != null
                  ? formatCurrency(totalWajibAnim.value)
                  : formatCurrency(0),
              'Simpanan Wajib'),
          _buildUserStatsItem(
              totalSukarelaAnim != null
                  ? formatCurrency(totalSukarelaAnim.value)
                  : formatCurrency(0),
              'Simpanan Sukarela'),
        ],
      ),
    );
  }

  Widget _buildUserStatsItem(String value, String text) {
    return Column(
      children: <Widget>[
        Text(
          value.toString(),
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: nameDescriptionTextStyle,
        ),
      ],
    );
  }

  //Styling

  final ParentStyle userCardStyle = ParentStyle()
    ..height(120)
    ..padding(horizontal: 5.0, vertical: 0)
    ..alignment.center()
    ..background.color(Colors.green);
//    ..borderRadius(all: 20.0)
//    ..elevation(0, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 30)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TextStyle nameTextStyle = TextStyle(
      color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600);

  final TextStyle nameDescriptionTextStyle =
      TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.0);
}
