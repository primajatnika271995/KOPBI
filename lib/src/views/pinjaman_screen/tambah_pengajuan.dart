import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/barangApi.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:kopbi/src/views/pinjaman_screen/list_pinjaman.dart';
import 'package:kopbi/src/views/pinjaman_screen/upload_verifikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanTambahPage extends StatefulWidget {
  @override
  _PengajuanTambahPageState createState() => _PengajuanTambahPageState();
}

class _PengajuanTambahPageState extends State<PengajuanTambahPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  ListBarang _dbBarang;
  ListSimpanan _listSimpanan;

  TextEditingController _keteranganController;
  var _keteranganBarangController = TextEditingController();
  MoneyMaskedTextController _nominalPengajuanController;

  FocusNode _keteranganFocus;
  FocusNode _nominalFocus;

  String _statusAnggota;

  //Post data
  String _kodeTipePengajuan;
  String _tipePengajuan;
  String _keterangan;
  String _kodeBarang;
  String _namaBarang;
  double _persenBunga;
  int _nominalPengajuan;
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

  double _dLamaAngsuran;

  bool isLoading;

  List<Barang> _listBarang;
  List<Map<String, dynamic>> _listPerumahan;

  @override
  // TODO: implement widget
  PengajuanTambahPage get widget => super.widget;

  bool _isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDetails();
    getDataSimpanan();

    _scaffoldKey = new GlobalKey<ScaffoldState>();

    _listBarang = [];

    _dbBarang = ListBarang();

    _dbBarang.getList().then((_) {
      switch (_) {
        case HttpStatus.success:
          _listBarang = _dbBarang.listBarang;
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

    isLoading = false;

    _quickNominalSelected = 500000;

    _dLamaAngsuran = 1;

    _kodeTipePengajuan = 'UANG';
    _tipePengajuan = 'Uang';
    _nominalPengajuan = 500000;
    _lamaAngsuran = 1;
//    _persenBunga = (2 / _dLamaAngsuran);
    _persenBunga = 2;
    _nominalBunga = 0;
    _totalBunga = 0;
    _biayaAdmin = 5000;

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

    _keteranganFocus = new FocusNode();
    _nominalFocus = new FocusNode();

    _keterangan = '';
    _keteranganController = new TextEditingController();
    _keteranganController.addListener(() {
      setState(() {
        _keterangan = _keteranganController.text;
      });
    });

    _nominalPengajuanController =
        new MoneyMaskedTextController(precision: 0, decimalSeparator: '');
    _nominalPengajuanController.addListener(() {
      setState(() {
        if (_nominalPengajuanController.text.isEmpty) {
          //_nominalPengajuan = 0;
          _nominalPengajuanController.text = '0';
        } else {
          _nominalPengajuan = int.parse(_nominalPengajuanController.text
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
      _statusAnggota = _pref.getString(STATUS_ANGGOTA);
    });
  }

  void getDataSimpanan() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var _nik = _pref.getString(NOMOR_ANGGOTA);
    _listSimpanan = ListSimpanan();

    totalSimpanan = _listSimpanan.totalSum;

    print(_nik);

    _listSimpanan.getList(nik: _nik).then((_) {
      setState(() {
        totalSimpanan = _listSimpanan.totalSum;
        print(_listSimpanan.formattedTotalSum);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nominalPengajuanController.dispose();

    super.dispose();
  }

  Future<bool> isRequirementPassed() async {
    ListSimpanan _dbSimpanan = ListSimpanan();

    await _dbSimpanan.getList(nik: nomorAnggota);

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
      "lokasiPenempatan": lokasiPenempatan,
      "namaPerusahaan": namaPerusahaan,
      "alamatPerusahaan": alamatPerusahaan,
      "emailPerusahaan": emailPerusahaan,
      "tanggalPengajuan": new DateTime.now().toString(),
      "lamaAngsuran": _lamaAngsuran.toString(),
      "nominalAngsuran": _nominalAngsuran.toString(),
      "nominalPengajuan": _nominalPengajuan.toString(),
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

      if (_statusAnggota == "N" || _statusAnggota == "I") {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Anda belum dapat melakukan pinjaman"),
        ));
        return;
      }

      if (_keterangan.isEmpty) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Harap isi tujuan pinjaman"),
        ));
        return;
      }

      if (await isRequirementPassed() == false) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Maaf iuran wajib anda kurang dari 6 bulan"),
        ));
        return;
      }

      if (_pref.getString(NAMA_ANGGOTA) == null || _pref.getString(NAMA_ANGGOTA).isEmpty
          || _pref.getString(NO_KTP) == null || _pref.getString(NO_KTP).isEmpty
          || _pref.getString(JENIS_KELAMIN) == null || _pref.getString(JENIS_KELAMIN).isEmpty
          || _pref.getString(TEMPAT_LAHIR) == null || _pref.getString(TEMPAT_LAHIR).isEmpty
          || _pref.getString(TANGGAL_LAHIR) == null || _pref.getString(TANGGAL_LAHIR).isEmpty
          || _pref.getString(STATUS_PERKAWINAN) == null || _pref.getString(STATUS_PERKAWINAN).isEmpty
          || _pref.getString(ALAMAT) == null || _pref.getString(ALAMAT).isEmpty
          || _pref.getString(PEKERJAAN) == null || _pref.getString(PEKERJAAN).isEmpty
          || _pref.getString(EMAIL_PRIBADI) == null || _pref.getString(EMAIL_PRIBADI).isEmpty
          || _pref.getString(CONTACT_ANGGOTA) == null || _pref.getString(CONTACT_ANGGOTA).isEmpty
          || _pref.getString(NAMA_KONFEDERENSI) == null || _pref.getString(NAMA_KONFEDERENSI).isEmpty
          || _pref.getString(NAMA_PERUSAHAAN) == null || _pref.getString(NAMA_PERUSAHAAN).isEmpty
          || _pref.getString(LOKASI_PENEMPATAN) == null || _pref.getString(LOKASI_PENEMPATAN).isEmpty
          || _pref.getString(NIK) == null || _pref.getString(NIK).isEmpty
          || _pref.getString(JABATAN_KEANGGOTAAN) == null || _pref.getString(JABATAN_KEANGGOTAAN).isEmpty
          || _pref.getString(PENDAPATAN) == null || _pref.getString(PENDAPATAN).isEmpty
          || _pref.getString(NAMA_SAUDARA_DEKAT) == null || _pref.getString(NAMA_SAUDARA_DEKAT).isEmpty
          || _pref.getString(HUBUNGAN_SAUDARA) == null || _pref.getString(HUBUNGAN_SAUDARA).isEmpty
          || _pref.getString(ALAMAT_SAUDARA) == null || _pref.getString(ALAMAT_SAUDARA).isEmpty
          || _pref.getString(NO_HP_SAUDARA) == null || _pref.getString(NO_HP_SAUDARA).isEmpty
          || _pref.getString(NAMA_BANK) == null || _pref.getString(NAMA_BANK).isEmpty
          || _pref.getString(NOMOR_REKENING) == null || _pref.getString(NOMOR_REKENING).isEmpty
          || _pref.getString(SIMPANAN_WAJIB) == null || _pref.getString(SIMPANAN_WAJIB).isEmpty
          || _pref.getString(CABANG_BANK) == null || _pref.getString(CABANG_BANK).isEmpty || _pref.getString(CABANG_BANK) == "-"
          || _pref.getString(SIMPANAN_SUKARELA) == null || _pref.getString(SIMPANAN_SUKARELA).isEmpty) {

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Harap Lengkapi Data Anggota terlebih dahulu."),
        ));
        return;
      }

      if (_pref.getString(IMG_KTP) == null || _pref.getString(IMG_KTP).isEmpty) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Silahkan Upload Foto KTP di Kelengkapan Data."),
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
//        showDialog(
//            context: context,
//            builder: (_) => new AlertDialog(
//              title: Text('Terima Kasih'),
//              content: Text('Pengajuan anda berhasil dibuat. Lakukan pengecekan secara berkala untuk mengetahui proses pengajuan anda.'),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: () {
//                    Navigator.pop(context);
//                    Navigator.pop(context);
//                  },
//                  child: Text('Selesai'),
//                ),
//              ],
//            )
//        );
        MessageModel value =
            messageModelFromJson(json.encode(uriResponse.data));
        Map<String, dynamic> response = jsonDecode(value.data);
        if (response['success'] == true) {
          /* _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Pengajuan pinjaman berhasil dibuat"),
          )); */

          if (_nominalPengajuan > 2000000) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UploadFotoVerifikasi(),
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
      print('Error detail');
      print(e);
      print('End error detail');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Periksa kembali pengajuan anda"),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
      client.close();
    }
  }

  void _nominalQuickSelect(int selected) {
    setState(() {
      _nominalPengajuanController.text = '0';
      _nominalPengajuan = selected;
      _quickNominalSelected = selected;
    });
  }

  String hitungPokok() {
    setState(() {
      _pokok = ((_nominalPengajuan / _lamaAngsuran).round() / 100).ceil() * 100;
      _pokokController.text = _pokok.toString();
    });

    return _pokokController.text;
  }

  String hitungBunga() {
    setState(() {
      if (_nominalPengajuan < totalSimpanan) {
        setState(() {
          _persenBunga = (8 / 12);
        });
      } else if (_nominalPengajuan > totalSimpanan) {
        setState(() {
          _persenBunga = 2;
        });
      }

      print("ini total simpanan : $totalSimpanan");
      print("ini bagi hasil : $_persenBunga");

      _bunga =
          ((_nominalPengajuan * ((_persenBunga) / 100)).round() / 100).ceil() *
              100;
      _nominalBunga = _bunga;
      _totalBunga = _bunga * _lamaAngsuran;
      _bungaController.text = _bunga.toString();
    });

    return _bungaController.text;
  }

  String hitungAdmin() {
    setState(() {
      _admin = _biayaAdmin.round();
      _adminController.text = _admin.toString();
    });

    return _adminController.text;
  }

  String hitungTotalTagihan() {
    setState(() {
      _nominalAngsuran = _pokok + _bunga + _biayaAdmin;
      _nominalAngsuranController.text = _nominalAngsuran.toString();
    });

    return _nominalAngsuranController.text;
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
        title: Text("Ajukan Pinjaman"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          children: <Widget>[
//            Text("Pilih jenis pengajuan", style: TextStyle(fontSize: 18)),
//            SizedBox(height: 8),
//            Container(
//              decoration: BoxDecoration(
//                border: Border.all(color: Colors.lightGreen),
//              ),
//              child: Padding(
//                padding: EdgeInsets.symmetric(vertical: 10.0),
//                child: Row(
//                  children: <Widget>[
//                    jenisButton(
//                        asset: "uang",
//                        label: "Uang",
//                        active: _tipePengajuan == 'Uang',
//                        callback: () {
//                          setState(() {
//                            _kodeTipePengajuan = 'UANG';
//                            _tipePengajuan = 'Uang';
//                            _nominalQuickSelect(500000);
//                          });
//                        }),
//                    jenisButton(
//                        asset: "barang",
//                        label: "Barang",
//                        active: _tipePengajuan == 'Barang',
//                        callback: () {
//                          setState(() {
//                            _kodeTipePengajuan = 'BRG';
//                            _tipePengajuan = 'Barang';
//                            _quickNominalSelected = null;
//                            if (_listBarang.length > 0) {
//                              _barang = _listBarang.first.namaBarang;
//                              _keteranganBarang = _listBarang.first.keterangan;
//                              _nominalPengajuanController.text =
//                                  _listBarang.first.harga.toString();
//                              _keteranganBarangController.text =
//                                  _listBarang.first.keterangan;
//                            } else {
//                              _barang = "Tidak ada barang";
//                              _nominalPengajuan = 0;
//                            }
//                          });
//                        }),
//                    /* jenisButton(
//                      asset: "perumahan",
//                      label: "Perumahan",
//                      active: _tipePengajuan == 'Perumahan',
//                      callback: () {
//                        _scaffoldKey.currentState.showSnackBar(SnackBar(
//                          content: Text("Sementara tidak tersedia"),
//                        ));
//                        /* setState(() {
//                          _kodeTipePengajuan = 'PERUM';
//                          _tipePengajuan = 'Perumahan';
//                          _quickNominalSelected = null;
//                          _perumahan = _listPerumahan.first['nama'];
//                          _nominalPengajuanController.text = _listPerumahan.first['harga'].toString();
//                        }); */
//                      }
//                    ), */
//                  ],
//                ),
//              ),
//            ),

            //Detail
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
              ),
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  //Nominal
                  _tipePengajuan == 'Uang'
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Berapa banyak?',
                                  style: TextStyle(fontSize: 18.0)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            width: 130,
                                            child: FlatButton(
                                              color: _quickNominalSelected ==
                                                      500000
                                                  ? Colors.green
                                                  : Colors.grey,
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Text("Rp. 500.000"),
                                              onPressed: () {
                                                _nominalQuickSelect(500000);
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 130,
                                            child: FlatButton(
                                              color: _quickNominalSelected ==
                                                      1000000
                                                  ? Colors.green
                                                  : Colors.grey,
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Text("Rp. 1.000.000"),
                                              onPressed: () {
                                                _nominalQuickSelect(1000000);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            width: 130,
                                            child: FlatButton(
                                              color: _quickNominalSelected ==
                                                      1500000
                                                  ? Colors.green
                                                  : Colors.grey,
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Text("Rp. 1.500.000"),
                                              onPressed: () {
                                                _nominalQuickSelect(1500000);
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 130.0,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _nominalPengajuanController,
                                              textInputAction:
                                                  TextInputAction.done,
                                              focusNode: _nominalFocus,
                                              onSaved: (_) {
                                                _nominalFocus.unfocus();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Pilih " + _tipePengajuan,
                                  style: TextStyle(fontSize: 18.0)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: _tipePengajuan == 'Barang'
                                    ? DropdownButton<String>(
                                        isExpanded: true,
                                        value: _barang,
                                        items: _listBarang.length > 0
                                            ? _listBarang.map((_) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: _.namaBarang,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0),
                                                    child: new Text(
                                                      _.namaBarang,
                                                      style: TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                );
                                              }).toList()
                                            : [
                                                DropdownMenuItem<String>(
                                                  value: "Tidak ada barang",
                                                  child: new Text(
                                                    "Tidak ada barang",
                                                    style: TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                )
                                              ],
                                        onChanged: (v) {
                                          if (_listBarang.length > 0) {
                                            print(_listBarang[0].namaBarang);
                                            setState(() {
                                              _barang = v;
                                              _kodeBarang = _listBarang
                                                  .firstWhere(
                                                      (_) => _.namaBarang == v)
                                                  .kodeBarang;
                                              _namaBarang = _listBarang
                                                  .firstWhere(
                                                      (_) => _.namaBarang == v)
                                                  .namaBarang;
                                              _nominalPengajuanController.text =
                                                  _listBarang
                                                      .firstWhere((_) =>
                                                          _.namaBarang == v)
                                                      .harga
                                                      .toString();
                                              _keteranganBarangController.text =
                                                  _listBarang
                                                      .firstWhere((_) =>
                                                          _.keterangan == v)
                                                      .keterangan;
                                            });
                                          }
                                        },
                                      )
                                    : DropdownButton<String>(
                                        isExpanded: true,
                                        value: _perumahan,
                                        items: _listPerumahan.map((_) {
                                          return new DropdownMenuItem<String>(
                                            value: _['nama'],
                                            child: new Text(
                                              _['nama'],
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            _perumahan = v;
                                            //_kodeBarang = _listPerumahan.firstWhere((_) => _['nama'] == v)['kode'];
                                            //_namaBarang = _listPerumahan.firstWhere((_) => _['nama'] == v)['nama'];
                                            _kodeBarang = null;
                                            _namaBarang = null;
                                            _nominalPengajuanController.text =
                                                _listPerumahan
                                                    .firstWhere((_) =>
                                                        _['nama'] == v)['harga']
                                                    .toString();
                                          });
                                        },
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  height: 40.0,
                                  width: 330.0,
                                  child: TextFormField(
                                    enabled: false,
                                    controller: _keteranganBarangController,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  height: 40.0,
                                  width: 330.0,
                                  child: TextFormField(
                                    enabled: false,
                                    controller: _nominalPengajuanController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                  //Keterangan
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 20.0, left: 10, right: 10, top: 10),
                    child: TextFormField(
                      controller: _keteranganController,
                      maxLines: null,
                      focusNode: _keteranganFocus,
                      decoration: InputDecoration(
                          labelText: "Tujuan pinjaman",
                          labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                      onEditingComplete: () {
                        _keteranganFocus.unfocus();
                      },
                    ),
                  ),

                  //Tenor
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Berapa lama tenor yang diinginkan?",
                            style: TextStyle(fontSize: 18.0)),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Slider(
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey,
                                value: _dLamaAngsuran,
                                min: 1.0,
                                max: 12.0,
                                divisions: 12,
                                onChanged: (v) {
                                  setState(() {
                                    _dLamaAngsuran = v;
                                    _lamaAngsuran = v.round();
                                  });
                                },
                              ),
                              Center(
                                child: Text(_lamaAngsuran.toString() + ' Bulan',
                                    style: TextStyle(fontSize: 24.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),

                  //Review
                  Container(
                    decoration: BoxDecoration(color: Colors.lightGreen),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Jatuh tempo",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Text("Pokok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Text("Bagi Hasil",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Text("Administrasi",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              SizedBox(height: 10.0),
                              Text("Total tagihan",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Tanggal 15 bulan selanjutnya",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text(hitungPokok(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text(hitungBunga(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text(hitungAdmin(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text(hitungTotalTagihan(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                    text: TextSpan(
                      children: [
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
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.of(context).pushNamed('/ketentuan-kebijakan');
                            }
                        ),
                        TextSpan(
                          text: "yang berlaku",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]
                    ),
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
                onPressed: _isCheck ? () {
                  if (!isLoading) {
                    submit(context: context);
                  }
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
