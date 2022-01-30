import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/pengajuan.dart';
import 'package:kopbi/src/services/pinjaman.dart';
import 'package:kopbi/src/services/userApi.dart';
import 'package:kopbi/src/views/component/transition/fade_transition.dart';
import 'package:kopbi/src/views/pinjaman_screen/angsuran.dart';
import 'package:kopbi/src/views/pinjaman_screen/tambah_pengajuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriPengajuanUangListPage extends StatefulWidget {
  static String tag = 'pengajuan-list-page';

  HistoriPengajuanUangListPage({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final User user;

  @override
  _HistoriPengajuanUangListPageState createState() => _HistoriPengajuanUangListPageState();
}

class _HistoriPengajuanUangListPageState extends State<HistoriPengajuanUangListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  User _user;

  ListPengajuan _dbPengajuan;
  ListPinjaman _dbPinjaman;

  List<Pengajuan> _listPengajuan;
  List<Pinjaman> _listPinjaman;

  List<Map<String, dynamic>> _listData;

  Map<String, bool> _listPengajuanActive;
  Map<String, bool> _listDataActive;

  Map<String, String> _prosesPengajuan;

  bool isLoading;

  String nik;

  @override
  // TODO: implement widget
  HistoriPengajuanUangListPage get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("HISTORY");

    isLoading = false;

    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _user = widget.user;

    _prosesPengajuan = {
      'new': 'Menunggu Verifikasi HRD',
      'app': 'Menunggu Verifikasi Pengawas',
      'vrf': 'Menunggu Proses Admin',
      'can': 'Batal',
      'can-hrd': 'Ditolak HRD',
      'can-pengawas': 'Ditolak Pengawas',
      'proc': 'Sedang Diproses',
    };

    _listPengajuan = [];
    _listPinjaman = [];
    _listData = [];

    _listPengajuanActive = {};
    _listDataActive = {};

    _dbPengajuan = ListPengajuan();
    _dbPinjaman = ListPinjaman();

    getListData();
  }

  //void getListData() {
  void getListData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      nik = _pref.getString(NIK);
    });

    _listData = [];

    await _dbPengajuan.getList(nik: nik);
    _listPengajuan = _dbPengajuan.listPengajuan;

    await _dbPinjaman.getList(nik: nik);
    _listPinjaman = _dbPinjaman.listPinjaman;

    setState(() {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() != 'proc' && _.statusPengajuan.toLowerCase() != 'can' && _.statusPengajuan.toLowerCase() != 'new' && _.statusPengajuan.toLowerCase() != 'app' && _.statusPengajuan.toLowerCase() != 'vrf' && _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuan,
            'tanggalAppHRD': _.tanggalAppHRD,
            'tanggalAppPengawas': _.tanggalAppPengawas,
            'namaHRD': _.namaUserHRD,
            'namaPengawas': _.namaUserPengawas,
            'catatanHRD': _.catatanHRD,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
//
//      _listPinjaman.forEach((_) {
//        if (_.statusPinjaman.toLowerCase() != 'proc' && _.statusPinjaman.toLowerCase() != 'can') {
//          _listData.add({
//            'typeof': 'pinjaman',
//            'kode': _.nomorPinjaman,
//            'tipe': _.tipePengajuan,
//            'status': _.statusPinjaman,
//            'formattedNominal': _.formattedNominalPinjaman,
//            'tanggal': _.tanggalPengajuan,
//          });
//        }
//      });

      _listData.sort((a, b) {
        String tglTglA = a['tanggal'].day.toString();
        String tglBlnA = a['tanggal'].month.toString();
        String tglThnA = a['tanggal'].year.toString();
        String tglHourA = a['tanggal'].hour.toString();
        String tglMinuteA = a['tanggal'].minute.toString();
        String tglSecondA = a['tanggal'].second.toString();

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

        String tglTglB = b['tanggal'].day.toString();
        String tglBlnB = b['tanggal'].month.toString();
        String tglThnB = b['tanggal'].year.toString();
        String tglHourB = b['tanggal'].hour.toString();
        String tglMinuteB = b['tanggal'].minute.toString();
        String tglSecondB = b['tanggal'].second.toString();

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

      _listDataActive = {};

      _listData.forEach((_) {
        _listDataActive[_['kode']] = false;
      });

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void batalkan(Pengajuan pengajuan) async {
//    var client = new http.Client();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var token = _pref.getString(JWT_TOKEN);
    var dio = new Dio();

    try {
      String url = "${APIUrl.pengajuan}/post-pengajuan";

      Map<String, String> postdata = pengajuan.toMap();

      postdata['statusPengajuan'] = 'CAN';

      setState(() {
        isLoading = true;
      });

      print('Updating Status Pengajuan');

      var uriResponse = await dio.post(url, options: Options(
          headers: {
            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
            'jwtToken': token,
          }
      ), data: jsonEncode(postdata));

      if (uriResponse.statusCode == 200) {
        MessageModel value = messageModelFromJson(json.encode(uriResponse.data));
        Map<String, dynamic> response = jsonDecode(value.data);
        if (response['success'] == true) {
          getListData();

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Pengajuan pinjaman berhasil dibatalkan"),
          ));
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Terjadi kesalahan pada proses pembatalan pengajuan"),
        ));
      }
    } catch (e) {
      print('Error detail');
      print(e);
      print('End error detail');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Tidak dapat terhubung dengan server"),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Histori Pengajuan"),
      ),
      body: Container(
        color: Colors.white,
        //child: _listPengajuan.length == 0 ?
        child: _listData.length == 0
            ? Center(
            child: isLoading == true
                ? CircularProgressIndicator(strokeWidth: 6.0)
                : Text('Tidak ada Histori Pengajuan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.black45)))
            : ListView.builder(
          //itemCount: _listPengajuan.length,
          itemCount: _listData.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = _listData[index];
            //Pengajuan pinjaman = _listPengajuan[index];
            Image jenisIcon;
            Color statusColor;

            if (data['typeof'] == 'pinjaman') {
              if (data['status']
                  .toString()
                  .toLowerCase()
                  .contains('belum')) {
                data['status'] = 'Belum Lunas';
              } else {
                data['status'] = 'Lunas';
              }
            }

            //switch (pinjaman.tipePengajuan.toLowerCase()) {
            switch (data['tipe'].toLowerCase()) {
              case 'uang':
                jenisIcon = Image.asset('assets/icons/uang.png');
                break;
              case 'barang':
                jenisIcon = Image.asset('assets/icons/barang.png');
                break;
              case 'perumahan':
                jenisIcon = Image.asset('assets/icons/perumahan.png');
                break;
            }

            //if(pinjaman.statusPengajuan.toLowerCase().contains('can')) {
            if (data['status'].toLowerCase().contains('can')) {
              statusColor = Color.fromARGB(255, 194, 9, 9);
            } else {
              statusColor = Colors.blue;
            }

            return Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    if (data['typeof'] == 'pengajuan') {
                      //if(!pinjaman.statusPengajuan.toLowerCase().contains('can')) {
                      if (!data['status']
                          .toLowerCase()
                          .toString()
                          .contains('can')) {
                        setState(() {
                          /* _listPengajuanActive.forEach((k, v) {
                              if(k != pinjaman.kodePengajuan) _listPengajuanActive[k] = false;
                            });
                            _listPengajuanActive[pinjaman.kodePengajuan] = !_listPengajuanActive[pinjaman.kodePengajuan]; */

                          _listDataActive.forEach((k, v) {
                            if (k != data['kode'])
                              _listDataActive[k] = false;
                          });
                          _listDataActive[data['kode']] =
                          !_listDataActive[data['kode']];
                        });
                      }
                    } else {
                      Pinjaman pinjaman = _listPinjaman.firstWhere(
                              (_) => _.nomorPinjaman == data['kode']);
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: AngsuranListPage(
                                  user: widget.user,
                                  pinjaman: pinjaman)));
                    }
                  },
                  //contentPadding: _listPengajuanActive[pinjaman.kodePengajuan] == true ?
                  contentPadding: _listDataActive[data['kode']] == true
                      ? EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0)
                      : EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
//                  leading: CircleAvatar(
//                    backgroundColor: Colors.white,
//                    child: jenisIcon,
//                    foregroundColor: Colors.white,
//                    radius: 20,
//                  ),
                  title: Text('Tanggal Approve HRD', style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${dateFormat(data['tanggalAppHRD'])}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'NAMA HRD',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Text(
                        '${data['namaHRD']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Catatan HRD',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Text(
                        '${data['catatanHRD']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Tanggal Approve Pengawas',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Text(
                        '${dateFormat(data['tanggalAppPengawas'])}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'NAMA Pengawas',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Text(
                        '${data['namaPengawas']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Catatan Pengawas',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Text(
                        '${data['catatanPengawas']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: statusColor,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Text(
                      _prosesPengajuan[data['status'].toLowerCase()] !=
                          null
                          ? _prosesPengajuan[data['status'].toLowerCase()]
                          : data['status'],
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                _listDataActive[data['kode']] == true ?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                title: Text('Konfirmasi'),
                                content: Text('Anda yakin ingin membatalkan pengajuan?'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      //batalkan(pinjaman);

                                      Pengajuan pengajuan = _listPengajuan.firstWhere((_) => _.kodePengajuan == data['kode']);
                                      batalkan(pengajuan);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ya'),
                                  ),
                                  FlatButton(
                                    onPressed: () { Navigator.of(context).pop(); },
                                    child: Text('Tidak'),
                                  ),
                                ],
                              )
                          );
                        },
                        color: Color.fromARGB(255, 194, 9, 9),
                        textColor: Colors.white,
                        child: isLoading == true ?
                        Container(
                            height: 20.0,
                            width: 10.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                        ) :
                        Text("Batalkan", style: TextStyle(fontSize: 15.0)),
                      ),
                    ),
                  ],
                ) : Container()
              ],
            );
          },
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.of(context)
//              .push(
//            MaterialPageRoute(
//              builder: (context) => PengajuanTambahPage(),
//            ),
//          )
//              .then((_) {
//            returnBackData();
//          });
//        },
//        backgroundColor: Colors.green,
//        child: Icon(Icons.add),
//        tooltip: "Tambah pinjaman",
//      ),
    );
  }

  void returnBackData() {
    getListData();
  }
}
