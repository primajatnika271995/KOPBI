import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/services/pinjamanApi.dart';
import 'package:kopbi/src/views/pinjaman_screen/tambah_pengajuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanListPage extends StatefulWidget {
  @override
  _PengajuanListPageState createState() => _PengajuanListPageState();
}

class _PengajuanListPageState extends State<PengajuanListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  ListPengajuan _dbPengajuan;

  List<Pengajuan> _listPengajuan;

  List<Map<String, dynamic>> _listData;

  Map<String, bool> _listPengajuanActive;
  Map<String, bool> _listDataActive;

  Map<String, String> _prosesPengajuan;

  bool isLoading;

  String nik;

  @override
  // TODO: implement widget
  PengajuanListPage get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = false;
    _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    _listData = [];

    _listPengajuanActive = {};
    _listDataActive = {};

    _dbPengajuan = ListPengajuan();

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

    setState(() {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() != 'proc') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuan,
          });
        }
      });

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
    var client = new http.Client();

    try {
      String url = "${APIUrl.pengajuan}/post-pengajuan";

      Map<String, String> postdata = pengajuan.toMap();

      postdata['statusPengajuan'] = 'CAN';

      setState(() {
        isLoading = true;
      });

      print('Updating Status Pengajuan');

      var uriResponse = await client.post(url, body: jsonEncode(postdata));

      if (uriResponse.statusCode == 200) {
        Map<String, dynamic> response = jsonDecode(uriResponse.body);
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
      client.close();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Pengajuan"),
      ),
      body: Container(
        color: Colors.black12,
        child: _listData.length == 0
            ? Center(
                child: isLoading == true
                    ? CircularProgressIndicator(strokeWidth: 6.0)
                    : Text('Tidak ada pinjaman',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.black45)))
            : ListView.builder(
                itemCount: _listData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = _listData[index];
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
                      jenisIcon = Image.asset('assets/perumahan.png');
                      break;
                  }

                  //if(pinjaman.statusPengajuan.toLowerCase().contains('can')) {
                  if (data['status'].toLowerCase().contains('can')) {
                    statusColor = Colors.red;
                  } else {
                    statusColor = Colors.blueAccent;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                if (data['typeof'] == 'pengajuan') {
                                  if (!data['status']
                                      .toLowerCase()
                                      .toString()
                                      .contains('can')) {
                                    setState(() {
                                      _listDataActive.forEach((k, v) {
                                        if (k != data['kode'])
                                          _listDataActive[k] = false;
                                      });
                                      _listDataActive[data['kode']] =
                                          !_listDataActive[data['kode']];
                                    });
                                  }
                                }
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: jenisIcon,
                                foregroundColor: Colors.white,
                                radius: 20,
                              ),
                              title: Text('Pinjaman ${data['tipe']}'),
                              subtitle: Text(
                                'Tanggal Pengajuan ${dateFormat(data['tanggal'])}',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                data['formattedNominal'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              color: statusColor,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                child: Text(
                                  _prosesPengajuan[
                                              data['status'].toLowerCase()] !=
                                          null
                                      ? _prosesPengajuan[
                                          data['status'].toLowerCase()]
                                      : data['status'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[],
                      secondaryActions: _listDataActive[data['kode']] == true
                          ? <Widget>[
                              IconSlideAction(
                                caption: 'Details',
                                color: Colors.black45,
                                icon: Icons.more_horiz,
                                onTap: () {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Details Pengajuan",
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconSlideAction(
                                caption: 'Batalkan',
                                color: Colors.red,
                                icon: Icons.cancel,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                          'Anda yakin ingin membatalkan pengajuan?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            //batalkan(pinjaman);

                                            Pengajuan pengajuan =
                                                _listPengajuan.firstWhere((_) =>
                                                    _.kodePengajuan ==
                                                    data['kode']);
                                            batalkan(pengajuan);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Ya'),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Tidak'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ]
                          : [],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PengajuanTambahPage(),
            ),
          ).then((_) {
            returnBackData();
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        tooltip: "Tambah pinjaman",
      ),
    );
  }

  void returnBackData() {
    getListData();
  }
}



