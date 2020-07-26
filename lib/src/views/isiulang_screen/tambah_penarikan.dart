import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:division/division.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/barangApi.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/views/isiulang_screen/upload_verifikasi_penarikan.dart';
import 'package:kopbi/src/views/pinjaman_screen/upload_verifikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPenarikan extends StatefulWidget {
  @override
  _TambahPenarikanState createState() => _TambahPenarikanState();
}

class _TambahPenarikanState extends State<TambahPenarikan>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey;
  ListSimpanan _dbSimpanan;

  double _tabActivePos;
  PageController _tabController;

  Timer timer;

  List<Simpanan> _listSimpanan;
  Map<String, bool> _listSimpananActive;

  bool isLoading;

  String nik;
  String namaAnggota;
  String namaJabatan = "Anggota";
  String imgUrl;

  TextEditingController _keteranganController;
  var _keteranganBarangController = TextEditingController();
  MoneyMaskedTextController _nominalPokokController;
  MoneyMaskedTextController _nominalWajibController;
  MoneyMaskedTextController _nominalSukarelaController;

  FocusNode _keteranganFocus;
  FocusNode _nominalFocus;

  //Post data
  String _kodeTipePengajuan;
  String _tipePengajuan;
  String _keterangan;
  String _kodeBarang;
  String _namaBarang;
  double _persenBunga;
  int _nominalPengajuanPokok;
  int _nominalPengajuanWajib;
  int _nominalPengajuanSukarela;
  int _lamaAngsuran;
  int _nominalBunga;
  int _totalBunga;
  int _biayaAdmin;

  int totalSimpanan;

  String nomorNik;
  String nomorKtp;
  String nomorAnggota;
  String nama;
  String nomorHp;
  String kodePerusahaan;
  String namaPerusahaan;
  String alamatPerusahaan;
  String lokasiPenempatan;
  String emailPerusahaan;
  String kodeAnggota;

  String kategoriPenarikan = 'Simpanan Pokok';

  //Only display
  String _barang;
  String _keteranganBarang;
  String _perumahan;
  int _quickNominalSelected;

  MoneyMaskedTextController _pokokController;
  MoneyMaskedTextController _bungaController;
  MoneyMaskedTextController _adminController;
  MoneyMaskedTextController _nominalAngsuranController;

  int _pokok;
  int _bunga;
  int _admin;
  int _nominalAngsuran;

  var _simpananPokokValue;
  var _simpananSukarelaValue;
  var _simpananWajibValue;

  double _dLamaAngsuran;

  List<Barang> _listBarang;
  List<Map<String, dynamic>> _listPerumahan;

  @override
  // TODO: implement widget
  TambahPenarikan get widget => super.widget;

  bool _isCheck = false;

  String formatCurrency(int number) {
    var f = new NumberFormat.currency(
        locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(number);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
    getDataSimpanan();

    _scaffoldKey = new GlobalKey<ScaffoldState>();

    isLoading = false;

    _quickNominalSelected = 500000;

    _dLamaAngsuran = 1;

    _kodeTipePengajuan = 'UANG';
    _tipePengajuan = 'Uang';
    _lamaAngsuran = 1;
//    _persenBunga = (2 / _dLamaAngsuran);
    _persenBunga = 2;
    _nominalBunga = 0;
    _totalBunga = 0;
    _biayaAdmin = 5000;

    _listSimpanan = [];
    _listSimpananActive = {};

    _dbSimpanan = ListSimpanan();

    _listPerumahan = [
      {
        'kode': 'CLST1',
        'nama': 'Cluster A',
        'harga': 150000000,
      },
      {
        'kode': 'CLST2',
        'nama': 'Cluster B',
        'harga': 250000000,
      },
      {
        'kode': 'CLST3',
        'nama': 'Cluster C',
        'harga': 300000000,
      }
    ];
    setState(() {
      getListSimpanan();
    });

    _keteranganFocus = new FocusNode();
    _nominalFocus = new FocusNode();

    _keterangan = '';
    _keteranganController = new TextEditingController();
    _keteranganController.addListener(() {
      setState(() {
        _keterangan = _keteranganController.text;
      });
    });

    _nominalPokokController =
        new MoneyMaskedTextController(precision: 0, decimalSeparator: '');

    _nominalWajibController =
    new MoneyMaskedTextController(precision: 0, decimalSeparator: '');

    _nominalSukarelaController =
    new MoneyMaskedTextController(precision: 0, decimalSeparator: '');

    _nominalPokokController.addListener(() {
      setState(() {
        if (_nominalPokokController.text.isEmpty) {
          //_nominalPengajuan = 0;
          _nominalPokokController.text = '0';
        } else {
          _nominalPengajuanPokok = int.parse(_nominalPokokController.text
              .replaceAll(new RegExp(r"[^\d]"), ''));
        }
        _quickNominalSelected = null;
      });
    });

    _nominalWajibController.addListener(() {
      setState(() {
        if (_nominalWajibController.text.isEmpty) {
          //_nominalPengajuan = 0;
          _nominalWajibController.text = '0';
        } else {
          _nominalPengajuanWajib = int.parse(_nominalWajibController.text
              .replaceAll(new RegExp(r"[^\d]"), ''));
        }
        _quickNominalSelected = null;
      });
    });

    _nominalSukarelaController.addListener(() {
      setState(() {
        if (_nominalSukarelaController.text.isEmpty) {
          //_nominalPengajuan = 0;
          _nominalSukarelaController.text = '0';
        } else {
          _nominalPengajuanSukarela = int.parse(_nominalSukarelaController.text
              .replaceAll(new RegExp(r"[^\d]"), ''));
        }
        _quickNominalSelected = null;
      });
    });

    _pokokController =
        new MoneyMaskedTextController(precision: 0, decimalSeparator: '');

    _bungaController =
        new MoneyMaskedTextController(precision: 0, decimalSeparator: '');

    _adminController =
        new MoneyMaskedTextController(precision: 0, decimalSeparator: '');

    _nominalAngsuranController =
        new MoneyMaskedTextController(precision: 0, decimalSeparator: '');
  }

  void getDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      nomorNik = _pref.getString(NIK);
      nomorKtp = _pref.getString(NO_KTP);
      nomorAnggota = _pref.getString(NOMOR_ANGGOTA);
      nama = _pref.getString(NAMA_ANGGOTA);
      nomorHp = _pref.getString(CONTACT_ANGGOTA);
      kodePerusahaan = _pref.getString(KODE_PERUSAHAAN);
      namaPerusahaan = _pref.getString(NAMA_PERUSAHAAN);
      alamatPerusahaan = _pref.getString(ALAMAT_PERUSAHAAN);
      lokasiPenempatan = _pref.getString(LOKASI_PENEMPATAN);
      emailPerusahaan = _pref.getString(EMAIL_PERUSAHAAN);
      kodeAnggota = _pref.getString(KODE_USER);

      namaAnggota = _pref.getString(NAMA_ANGGOTA);
      imgUrl = _pref.getString(IMG_PROFILE);
    });
  }

  void getDataSimpanan() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var _nik = _pref.getString(NIK);
    _dbSimpanan = ListSimpanan();

    totalSimpanan = _dbSimpanan.totalSum;

    print(_nik);

    _dbSimpanan.getList(nik: _nik).then((_) {
      setState(() {
        totalSimpanan = _dbSimpanan.totalSum;
        print(_dbSimpanan.formattedTotalSum);
      });
    });
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
//            _listSimpanan = _dbSimpanan.listSimpanan.where((i) => i.kodeSimpanan.toLowerCase() == 'spw').toList();

            _listSimpanan = _dbSimpanan.listSimpanan;
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> isRequirementPassed() async {
    ListSimpanan _dbSimpanan = ListSimpanan();

    await _dbSimpanan.getList(nik: nomorNik);

    if (_dbSimpanan.listSimpanan
            .where((simpanan) =>
                simpanan.jenisIuran.toLowerCase() == 'setoran' &&
                simpanan.namaSimpanan.toLowerCase() == 'simpanan wajib')
            .length >=
        6) return true;

    return false;
  }

  void submit({BuildContext context}) async {
    print('Prepare Submit');

    Map<String, String> postdata = {
      "kodeTipePengajuan": _kodeTipePengajuan,
      "tipePengajuan": _tipePengajuan,
      "nomorKtp": nomorKtp,
      "nomorAnggota": nomorAnggota,
      "nama": nama,
      "nomorNik": nomorNik,
      "nomorHp": nomorHp,
      "kodePerusahaan": kodePerusahaan,
      "namaPerusahaan": namaPerusahaan,
      "alamatPerusahaan": alamatPerusahaan,
      "lokasiPenempatan": lokasiPenempatan,
      "emailPerusahaan": emailPerusahaan,
      "tanggalPengajuan": new DateTime.now().toString(),
      "lamaAngsuran": _lamaAngsuran.toString(),
      "nominalAngsuran": _nominalAngsuran.toString(),
      "persenBunga": _persenBunga.toString(),
      "nominalBunga": _nominalBunga.toString(),
      "totalBunga": _totalBunga.toString(),
      "biayaAdmin": _biayaAdmin.toString(),
      "kodeBarang": _kodeBarang,
      "namaBarang": _namaBarang,
      "ambilDariKas": null,
      "ketKas": null,
      "keterangan": _keterangan.replaceAll("\n", "\\n"),
      "statusPengajuan": "NEW",
      "kategoriPengajuan": "PENARIKAN",
      "simpananPokok": _nominalPengajuanPokok.toString(),
      "simpananWajib": _nominalPengajuanWajib.toString(),
      "simpananSukarela": _nominalPengajuanSukarela.toString(),
      "tanggalPerubahan": null,
      "tanggalTempo": "15",
      "tanggalJatuhTempo": "15",
      "nomorPinjaman": null,
      "kodeUser": kodeAnggota,
      "namaUser": nama,
      "tanggalUpdate": null
    };

    var client = new http.Client();
    var dio = Dio();

    SharedPreferences _pref = await SharedPreferences.getInstance();

    var token = _pref.getString(JWT_TOKEN);

    try {
      setState(() {
        isLoading = true;
      });

      if (await isRequirementPassed() == false) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Maaf iuran wajib anda kurang dari 6 bulan"),
        ));
        return;
      }

      String url = "${APIUrl.pengajuan}/post-pengajuan";

      print('Submitting');

      var uriResponse = await dio.post(url,
          options: Options(headers: {
            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
            'jwtToken': token,
          }),
          data: jsonEncode(postdata));

      print(uriResponse.statusCode);
      print(uriResponse.data);

      if (uriResponse.statusCode == 200) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: Text('Terima Kasih'),
              content: Text('Pengajuan anda berhasil dibuat. Lakukan pengecekan secara berkala untuk mengetahui proses pengajuan anda.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Selesai'),
                ),
              ],
            )
        );
        MessageModel value =
            messageModelFromJson(json.encode(uriResponse.data));
        Map<String, dynamic> response = jsonDecode(value.data);
        if (response['success'] == true) {
          /* _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Pengajuan pinjaman berhasil dibuat"),
          )); */

          if (_nominalPengajuanPokok > 0 || _nominalPengajuanWajib > 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UploadFotoVerifikasiPenarikan(),
              ),
            );
          } else {
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: Text('Terima Kasih'),
                  content: Text('Pengajuan anda berhasil dibuat. Lakukan pengecekan secara berkala untuk mengetahui proses pengajuan anda.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Selesai'),
                    ),
                  ],
                )
            );
          }
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Terjadi kesalahan pada proses pengajuan"),
        ));
      }
    } catch (e) {
//      print('Error detail');
//      print(e);
//      print('End error detail');
//      _scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text("Tidak dapat terhubung dengan server"),
//      ));
    } finally {
      setState(() {
        isLoading = false;
      });
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget jenisButton(
        {String asset, bool active, String label, Function callback}) {
      return Expanded(
        child: Container(
          height: 85.0,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                splashColor: Color.fromARGB(255, 141, 197, 198),
                color: active
                    ? Color.fromARGB(255, 141, 197, 198)
                    : Colors.transparent,
                textColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(0.0),
                child:
                    Image.asset("assets/icons/" + asset + ".png", width: 60.0),
                onPressed: () {
                  callback();
                },
              ),
              SizedBox(height: 5.0),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ajukan Penarikan"),
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
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("Simpanan Pokok",
                        style: TextStyle(fontSize: 15.0)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _nominalPokokController,
                    textInputAction: TextInputAction.done,
                    focusNode: _nominalFocus,
                    onSaved: (_) {
                      _nominalFocus.unfocus();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Simpanan Wajib",
                        style: TextStyle(fontSize: 15.0)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _nominalWajibController,
                    textInputAction: TextInputAction.done,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Simpanan Sukarela",
                        style: TextStyle(fontSize: 15.0)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _nominalSukarelaController,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Checkbox(
                    value: _isCheck,
                    onChanged: (bool val) {
                      setState(() {
                        _isCheck = val;
                      });
                    }),
                Expanded(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Saya setuju dengan",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                          text: " Syarat dan Ketentuan ",
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushNamed('/ketentuan-kebijakan');
                            }),
                      TextSpan(
                        text: "yang berlaku",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),

            //Submit Button
            Padding(
              padding: EdgeInsets.only(top: 35.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.green,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: isLoading
                      ? Container(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white70),
                        )
                      : Text("Buat Pengajuan",
                          style: TextStyle(fontSize: 16.0)),
                ),
                onPressed: _isCheck
                    ? () {
                        if (!isLoading) {
                          submit(context: context);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
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
              _dbSimpanan.totalPokok != null
                  ? formatCurrency(_dbSimpanan.totalPokok)
                  : formatCurrency(0),
              'Simpanan Pokok'),
          _buildUserStatsItem(
              _dbSimpanan.totalWajib != null
                  ? formatCurrency(_dbSimpanan.totalWajib)
                  : formatCurrency(0),
              'Simpanan Wajib'),
          _buildUserStatsItem(
              _dbSimpanan.totalSukarela != null
                  ? formatCurrency(_dbSimpanan.totalSukarela)
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
