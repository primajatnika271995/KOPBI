import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/pengajuan.dart';
import 'package:kopbi/src/services/pinjaman.dart';
import 'package:kopbi/src/services/userApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/component/transition/fade_transition.dart';
import 'package:kopbi/src/views/isiulang_screen/tambah_penarikan.dart';
import 'package:kopbi/src/views/kredit_screen/histori_kredit.dart';
import 'package:kopbi/src/views/pinjaman_screen/angsuran.dart';
import 'package:kopbi/src/views/pinjaman_screen/tambah_pengajuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanPenarikanListPage extends StatefulWidget {
  static String tag = 'pengajuan-list-page';

  PengajuanPenarikanListPage({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final User user;

  @override
  _PengajuanPenarikanListPageState createState() => _PengajuanPenarikanListPageState();
}

class _PengajuanPenarikanListPageState extends State<PengajuanPenarikanListPage> {
  PersistentBottomSheetController _controller;
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
  String kodePerusahaan;
  String namaUser;

  final List<FilterGroup> _filterList = [
//    FilterGroup(index: 1, text: "Menunggu Verifikasi HRD"),
//    FilterGroup(index: 2, text: "Menunggu Verifikasi Pengawas"),
    FilterGroup(index: 3, text: "Batal"),
    FilterGroup(index: 4, text: "Selesai"),
    FilterGroup(index: 5, text: "Ditolak HRD"),
    FilterGroup(index: 6, text: "Ditolak Pengawas"),
  ];

  int _filterIndex = -1;
  String selectedFilter;

  @override
  // TODO: implement widget
  PengajuanPenarikanListPage get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    print("GET");
    print(_filterIndex);
    setState(() {
      isLoading = true;
    });

    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      nik = _pref.getString(NIK);
      kodePerusahaan = _pref.getString(KODE_PERUSAHAAN);
      namaUser = _pref.getString(NAMA_ANGGOTA);
    });

    _listData = [];

    await _dbPengajuan.getList(nik: nik, kategori: "PENARIKAN");
    _listPengajuan = _dbPengajuan.listPengajuan;

    await _dbPinjaman.getList(nik: nik);
    _listPinjaman = _dbPinjaman.listPinjaman;

    if (_filterIndex == -1) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() != 'can' &&
            _.statusPengajuan.toLowerCase() != 'can-hrd' &&
            _.statusPengajuan.toLowerCase() != 'proc' &&
            _.statusPengajuan.toLowerCase() != 'can-pengawas' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    } else if(_filterIndex == 1) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() == 'new' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    } else if(_filterIndex == 2) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() == 'app' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    } else if(_filterIndex == 3) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() == 'can' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    } else if(_filterIndex == 4) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() == 'proc' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    } else if(_filterIndex == 5) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() == 'can-hrd' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    } else if(_filterIndex == 6) {
      _listPengajuan.forEach((_) {
        if (_.statusPengajuan.toLowerCase() == 'can-pengawas' &&
            _.tipePengajuan.toLowerCase() != 'kendaraan' &&
            _.tipePengajuan.toLowerCase() != 'barang') {
          _listData.add({
            'typeof': 'pengajuan',
            'kode': _.kodePengajuan,
            'tipe': _.tipePengajuan,
            'status': _.statusPengajuan,
            'formattedNominal': _.formattedNominalPengajuan,
            'tanggal': _.tanggalPengajuanRaw,
            'tanggalUpdate': _.tanggalUpdate,
            'tanggalApproveHRD': _.tanggalAppHRD,
            'namaHRD': _.namaUserHRD,
            'catatanHRD': _.catatanHRD,
            'tanggalApprovePengawas': _.tanggalAppPengawas,
            'simpananPokok': _.simpananPokok,
            'simpananWajib': _.simpananWajib,
            'simpananSukarela': _.simpananSukarela,
            'namaPengawas': _.namaUserPengawas,
            'catatanPengawas': _.catatanPengawas,
          });
        }
      });
    }

    setState(() {
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
        String tglTglA = DateTime.parse(a['tanggal']).day.toString();
        String tglBlnA = DateTime.parse(a['tanggal']).month.toString();
        String tglThnA = DateTime.parse(a['tanggal']).year.toString();
        String tglHourA = DateTime.parse(a['tanggal']).hour.toString();
        String tglMinuteA = DateTime.parse(a['tanggal']).minute.toString();
        String tglSecondA = DateTime.parse(a['tanggal']).second.toString();

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

        String tglTglB = DateTime.parse(b['tanggal']).day.toString();;
        String tglBlnB = DateTime.parse(b['tanggal']).month.toString();
        String tglThnB = DateTime.parse(b['tanggal']).year.toString();
        String tglHourB = DateTime.parse(b['tanggal']).hour.toString();
        String tglMinuteB = DateTime.parse(b['tanggal']).minute.toString();
        String tglSecondB = DateTime.parse(b['tanggal']).second.toString();

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

      var uriResponse = await dio.post(url,
          options: Options(headers: {
            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
            'jwtToken': token,
          }),
          data: jsonEncode(postdata));

      if (uriResponse.statusCode == 200) {
        MessageModel value =
        messageModelFromJson(json.encode(uriResponse.data));
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
//      appBar: AppBar(
//        backgroundColor: Colors.green,
//        title: Text("Pengajuan"),
//      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            //child: _listPengajuan.length == 0 ?
            child: _listData.length == 0
                ? Center(
                child: isLoading == true
                    ? CircularProgressIndicator(strokeWidth: 6.0)
                    : Text('Tidak ada Penarikan',
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

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 4),
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
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 7, left: 5, bottom: 3),
                          child: Text(
                            'Tanggal Pengajuan ${data['tanggal']}',
                            style: TextStyle(color: Colors.grey,),
                          ),
                        ),
                        Divider(),
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

//                          _listDataActive.forEach((k, v) {
//                            if (k != data['kode'])
//                              _listDataActive[k] = false;
//                          });
//                          _listDataActive[data['kode']] =
//                          !_listDataActive[data['kode']];
                                });
                                print(_listDataActive[data['kode']]);
                              }
                            } else {
                              Pinjaman pinjaman = _listPinjaman.firstWhere(
                                      (_) => _.nomorPinjaman == data['kode']);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HistoriPengjuanKredit(
                                    tglApproveHrd: pinjaman.tanggalAppPengawas,
                                    namaHrd: pinjaman.namaUserHRD,
                                    catatanHrd: pinjaman.catatanHRD,
                                    tglApprovePengawas:
                                    pinjaman.tanggalAppPengawas,
                                    namaPengawas: pinjaman.namaUserPengawas,
                                    catatanPengawas: pinjaman.catatanPengawas,
                                  ),
                                ),
                              );
//                      Navigator.push(
//                          context,
//                          FadeRoute(
//                              page: AngsuranListPage(
//                                  user: widget.user,
//                                  pinjaman: pinjaman)));
                            }
                          },
                          //contentPadding: _listPengajuanActive[pinjaman.kodePengajuan] == true ?
                          contentPadding: _listDataActive[data['kode']] == true
                              ? EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0)
                              : EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: jenisIcon,
                            foregroundColor: Colors.white,
                            radius: 20,
                          ),
                          title: Text('Penarikan ${data['tipe']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'Simpanan Pokok ${NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0).format(data['simpananPokok'])}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Text(
                                'Simpanan Wajib Rp ${NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0).format(data['simpananWajib'])}',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Simpanan Sukarela Rp ${NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0).format(data['simpananSukarela'])}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        _listDataActive[data['kode']] == false
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: data['status'].toLowerCase().toString().contains('can') ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HistoriPengjuanKredit(
                                            tglApproveHrd: dateFormat(
                                                data['tanggalApproveHRD']),
                                            namaHrd: data['namaHRD'],
                                            catatanHrd: data['catatanHRD'],
                                            tglApprovePengawas: dateFormat(
                                                data['tanggalApprovePengawas']),
                                            namaPengawas: data['namaPengawas'],
                                            catatanPengawas: data['catatanPengawas'],
                                          ),
                                    ),
                                  );
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text("Histori",
                                    style: TextStyle(fontSize: 15.0)),
                              ),
                            ),
                            data['status'].toLowerCase().toString().contains('can') ? Container() :
                            Container(
                              child: FlatButton(
                                onPressed: () {
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
                                              _listPengajuan
                                                  .firstWhere((_) =>
                                              _.kodePengajuan ==
                                                  data['kode']);
                                              batalkan(pengajuan);
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                            child: Text('Ya'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                            child: Text('Tidak'),
                                          ),
                                        ],
                                      ));
                                },
                                color: Color.fromARGB(255, 194, 9, 9),
                                textColor: Colors.white,
                                child: isLoading == true
                                    ? Container(
                                    height: 20.0,
                                    width: 10.0,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation(
                                          Colors.white),
                                    ))
                                    : Text("Batalkan",
                                    style: TextStyle(fontSize: 15.0)),
                              ),
                            ),
                          ],
                        )
                            : Container()
                      ],
                    ),
                  ),
                );

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

//                          _listDataActive.forEach((k, v) {
//                            if (k != data['kode'])
//                              _listDataActive[k] = false;
//                          });
//                          _listDataActive[data['kode']] =
//                          !_listDataActive[data['kode']];
                            });
                            print(_listDataActive[data['kode']]);
                          }
                        } else {
                          Pinjaman pinjaman = _listPinjaman.firstWhere(
                                  (_) => _.nomorPinjaman == data['kode']);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HistoriPengjuanKredit(
                                tglApproveHrd: pinjaman.tanggalAppPengawas,
                                namaHrd: pinjaman.namaUserHRD,
                                catatanHrd: pinjaman.catatanHRD,
                                tglApprovePengawas:
                                pinjaman.tanggalAppPengawas,
                                namaPengawas: pinjaman.namaUserPengawas,
                                catatanPengawas: pinjaman.catatanPengawas,
                              ),
                            ),
                          );
//                      Navigator.push(
//                          context,
//                          FadeRoute(
//                              page: AngsuranListPage(
//                                  user: widget.user,
//                                  pinjaman: pinjaman)));
                        }
                      },
                      //contentPadding: _listPengajuanActive[pinjaman.kodePengajuan] == true ?
                      contentPadding: _listDataActive[data['kode']] == true
                          ? EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0)
                          : EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: jenisIcon,
                        foregroundColor: Colors.white,
                        radius: 20,
                      ),
                      title: Text('Penarikan ${data['tipe']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tanggal Pengajuan ${dateFormat(data['tanggal'])}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Simpanan Pokok ${NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0).format(data['simpananPokok'])}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            'Simpanan Wajib Rp ${NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0).format(data['simpananWajib'])}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Simpanan Sukarela Rp ${NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0).format(data['simpananSukarela'])}',
                            style: TextStyle(fontSize: 12),
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
                    _listDataActive[data['kode']] == false
                        ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: data['status'].toLowerCase().toString().contains('can') ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HistoriPengjuanKredit(
                                        tglApproveHrd: dateFormat(
                                            data['tanggalApproveHRD']),
                                        namaHrd: data['namaHRD'],
                                        catatanHrd: data['catatanHRD'],
                                        tglApprovePengawas: dateFormat(
                                            data['tanggalApprovePengawas']),
                                        namaPengawas: data['namaPengawas'],
                                        catatanPengawas: data['catatanPengawas'],
                                      ),
                                ),
                              );
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text("Histori",
                                style: TextStyle(fontSize: 15.0)),
                          ),
                        ),
                        data['status'].toLowerCase().toString().contains('can') ? Container() :
                        Container(
                          child: FlatButton(
                            onPressed: () {
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
                                          _listPengajuan
                                              .firstWhere((_) =>
                                          _.kodePengajuan ==
                                              data['kode']);
                                          batalkan(pengajuan);
                                          Navigator.of(context)
                                              .pop();
                                        },
                                        child: Text('Ya'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop();
                                        },
                                        child: Text('Tidak'),
                                      ),
                                    ],
                                  ));
                            },
                            color: Color.fromARGB(255, 194, 9, 9),
                            textColor: Colors.white,
                            child: isLoading == true
                                ? Container(
                                height: 20.0,
                                width: 10.0,
                                child: CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation(
                                      Colors.white),
                                ))
                                : Text("Batalkan",
                                style: TextStyle(fontSize: 15.0)),
                          ),
                        ),
                      ],
                    )
                        : Container()
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: 100,
              child: FlatButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.filter_list),
                    Spacer(),
                    Text("Filter")
                  ],
                ),
                onPressed: () {
                  filterSheet();
                },
                color: Colors.green,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => TambahPenarikan(),
            ),
          )
              .then((_) {
            returnBackData();
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        tooltip: "Tambah pinjaman",
      ),
    );
  }

  void filterSheet() async {
   showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                              child: Icon(Icons.close),
                          ),
                        ),
                        Text("Filter Pengajuan", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _filterIndex = -1;
                              });
                            },
                              child: Text("Reset"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      children: _filterList.map((e) =>
                          Row(
                            children: <Widget>[
                              Text(e.text),
                              Spacer(),
                              Radio(
                                value: e.index,
                                groupValue: _filterIndex,
                                materialTapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    _filterIndex = value;
                                    selectedFilter = e.text;

                                    print(_filterIndex);
                                    print(selectedFilter);
                                  });
                                },
                              )
                            ],
                          )).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(),
                  ),
                  Container(
                    width: screenWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                        onPressed: () {
                          returnBackData();
                          Navigator.pop(context);
                        },
                        child: Text("Terapkan"),
                        color: Colors.green,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
    },
    );
  }

  void returnBackData() {
    getListData();
  }
}

class FilterGroup {
  final int index;
  final String text;

  FilterGroup({this.index, this.text});
}
