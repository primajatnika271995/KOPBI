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
import 'package:kopbi/src/services/angsuran.dart';
import 'package:kopbi/src/services/pinjaman.dart';
import 'package:kopbi/src/services/userApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AngsuranListPage extends StatefulWidget {
  static String tag = 'angsuran-list-page';

  AngsuranListPage({Key key, this.title, this.user, this.pinjaman})
      : super(key: key);

  final String title;
  final User user;
  final Pinjaman pinjaman;

  @override
  _AngsuranListPageState createState() => _AngsuranListPageState();
}

class _AngsuranListPageState extends State<AngsuranListPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey;
  GlobalKey<AnimatedListState> _listKey;

  Pinjaman _pinjaman;

  Animation pokokAnim;
  Animation angsuranAnim;
  Animation sisaAnim;
  AnimationController totalAnimController;

  double _tabActivePos;
  PageController _tabController;

  Timer timer;

  ListAngsuran _dbAngsuran;

  List<Angsuran> _listAngsuran;
  List<Angsuran> _listAngsuranDisplay;

  int _totalAngsuranDibayar;

  bool isLoading;

  String nik;
  String namaAnggota;
  String namaJabatan = "Anggota";
  String imgUrl;

  @override
  // TODO: implement widget
  AngsuranListPage get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = false;

    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _listKey = new GlobalKey<AnimatedListState>();

    _pinjaman = widget.pinjaman;

    _listAngsuran = [];
    _listAngsuranDisplay = [];

    _totalAngsuranDibayar = 0;
    getUserDetails();

    _dbAngsuran = ListAngsuran();

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

  void getListSimpanan() {
    setState(() {
      isLoading = true;
    });

    _dbAngsuran.getList(nomorPinjaman: _pinjaman.nomorPinjaman).then((_) {
      switch (_) {
        case HttpStatus.success:
          setState(() {
            _listAngsuran = _dbAngsuran.listAngsuran;

            _listAngsuran.sort((a, b) {
              return a.angsuranKe.compareTo(b.angsuranKe);
            });

            _listAngsuranDisplay = _listAngsuran
                .where((_) => _.status.toLowerCase() == 'paid')
                .toList();

            /* _listAngsuran.sort((a, b) {
              String tglTglA = a.tanggalJatuhTempo.day.toString();
              String tglBlnA = a.tanggalJatuhTempo.month.toString();
              String tglThnA = a.tanggalJatuhTempo.year.toString();
              String tglHourA = a.tanggalJatuhTempo.hour.toString();
              String tglMinuteA = a.tanggalJatuhTempo.minute.toString();
              String tglSecondA = a.tanggalJatuhTempo.second.toString();

              if(tglTglA.length == 1) {
                tglTglA = "0$tglTglA";
              }
              if(tglBlnA.length == 1) {
                tglBlnA = "0$tglBlnA";
              }
              if(tglHourA.length == 1) {
                tglHourA = "0$tglHourA";
              }
              if(tglMinuteA.length == 1) {
                tglMinuteA = "0$tglMinuteA";
              }
              if(tglSecondA.length == 1) {
                tglSecondA = "0$tglSecondA";
              }

              String tglTglB = b.tanggalJatuhTempo.day.toString();
              String tglBlnB = b.tanggalJatuhTempo.month.toString();
              String tglThnB = b.tanggalJatuhTempo.year.toString();
              String tglHourB = b.tanggalJatuhTempo.hour.toString();
              String tglMinuteB = b.tanggalJatuhTempo.minute.toString();
              String tglSecondB = b.tanggalJatuhTempo.second.toString();

              if(tglTglB.length == 1) {
                tglTglB = "0$tglTglB";
              }
              if(tglBlnB.length == 1) {
                tglBlnB = "0$tglBlnB";
              }
              if(tglHourB.length == 1) {
                tglHourB = "0$tglHourB";
              }
              if(tglMinuteB.length == 1) {
                tglMinuteB = "0$tglMinuteB";
              }
              if(tglSecondB.length == 1) {
                tglSecondB = "0$tglSecondB";
              }

              int tglA = int.parse("$tglThnA$tglBlnA$tglTglA$tglHourA$tglMinuteA$tglSecondA");
              int tglB = int.parse("$tglThnB$tglBlnB$tglTglB$tglHourB$tglMinuteB$tglSecondB");

              return tglB.compareTo(tglA);
            }); */

            _listAngsuran.forEach((_) {
              if (_.status.toLowerCase() == 'paid') {
                setState(() {
                  _totalAngsuranDibayar += _.totalBayar;
                });
              }
            });

            showData();
          });
          print("List Angsuran Sukses");
          break;
        case HttpStatus.error:
          print("List Angsuran Error");
          break;
        case HttpStatus.serverError:
          print("List Angsuran Server Error");
          break;
        case HttpStatus.noInternet:
          print("List Angsuran No Internet");
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
    pokokAnim = IntTween(begin: 0, end: _pinjaman.nominalPinjaman).animate(
        CurvedAnimation(
            parent: totalAnimController, curve: Curves.easeInOutSine));
    angsuranAnim = IntTween(begin: 0, end: _pinjaman.nominalAngsuran).animate(
        CurvedAnimation(
            parent: totalAnimController, curve: Curves.easeInOutSine));
    sisaAnim = IntTween(
            begin: 0,
            end: (_pinjaman.lamaAngsuran * _pinjaman.nominalAngsuran) -
                _totalAngsuranDibayar)
        .animate(CurvedAnimation(
            parent: totalAnimController, curve: Curves.easeInOutSine));

    totalAnimController.forward();

    timer = Timer(Duration(milliseconds: 100), () {
      for (var i = 0; i < _listAngsuranDisplay.length; i++) {
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

    var a = dateTime.day + 1;

    String date = a.toString();

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

  Widget _buildItem(Angsuran angsuran, int index) {
    Color jenisColor = Colors.green;
    Color jenisShadowColor = Color.fromARGB(100, 30, 231, 106);

    String formatter = angsuran.tanggalJatuhTempo;

    String date = formatter.substring(8, 10);
    String month = formatter.substring(5, 7);
    String year = formatter.substring(0, 4);

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

    var mnt = int.parse(month);

    print("Tgl Jatuh Tempo ${angsuran.tanggalJatuhTempo} ");

    return ListTile(
      onTap: () {},
      title: Text(angsuran.status,
        style: TextStyle(
          color: jenisColor
        ),
      ),
      subtitle: Text("$date ${months[mnt]} $year",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: Text(
        angsuran.formattedTotalBayar,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700
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
            title: Text("Angsuran", style: TextStyle(color: Colors.white)),
            titleSpacing: 0,
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
            child: _listAngsuranDisplay.length == 0
                ? Center(
                    child: isLoading == true
                        ? CircularProgressIndicator(strokeWidth: 6.0)
                        : Text('Tidak ada angsuran',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.black45)))
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: 0,
                    itemBuilder:
                        (BuildContext context, int index, Animation animation) {
                      Angsuran angsuran = _listAngsuranDisplay[index];

                      return ScaleTransition(
                        scale: animation,
                        child: _buildItem(angsuran, index),
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
              pokokAnim != null
                  ? formatCurrency(pokokAnim.value)
                  : formatCurrency(0),
              'Pokok Pinjaman'),
          _buildUserStatsItem(
              angsuranAnim != null
                  ? formatCurrency(angsuranAnim.value)
                  : formatCurrency(0),
              'Angsuran'),
          _buildUserStatsItem(
              sisaAnim != null
                  ? formatCurrency(sisaAnim.value)
                  : formatCurrency(0),
              'Sisa Pinjaman'),
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
