import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/services/barangApi.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanKendaraan extends StatefulWidget {
  @override
  _PengajuanKendaraanState createState() => _PengajuanKendaraanState();
}

class _PengajuanKendaraanState extends State<PengajuanKendaraan> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  double _dLamaAngsuran = 11;
  int _lamaAngsuran = 11;

  ListBarang _dbBarang;
  ListSimpanan _listSimpanan;

  TextEditingController _keteranganController;
  var _keteranganBarangController = TextEditingController();
  MoneyMaskedTextController _nominalPengajuanController;

  FocusNode _keteranganFocus;

  //Post data
  String _kodeTipePengajuan;
  String _tipePengajuan;
  String _keterangan;
  String _kodeBarang;
  String _namaBarang;
  double _persenBunga;
  int _nominalPengajuan;
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

  MoneyMaskedTextController _pokokController;
  MoneyMaskedTextController _bungaController;
  MoneyMaskedTextController _adminController;
  MoneyMaskedTextController _nominalAngsuranController;

  int _pokok;
  int _bunga;
  int _admin;
  int _nominalAngsuran;

  Item selectedUser;

  bool isLoading;

  List<Barang> _listBarang;

  bool _isCheck = false;

  @override
  // TODO: implement widget
  PengajuanKendaraan get widget => super.widget;

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
          _listBarang = _dbBarang.listBarang.where((f) => f.stokBarang >= 1 && f.kategori == 'kendaraan').toList();
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

    _dLamaAngsuran = 11;

    _kodeTipePengajuan = 'KNDRN';
    _tipePengajuan = 'Kendaraan';

    _nominalPengajuan = 500000;
    _lamaAngsuran = 11;
//    _persenBunga = (2 / _dLamaAngsuran);
    _persenBunga = 2;
    _nominalBunga = 0;
    _totalBunga = 0;
    _biayaAdmin = 5000;

    _keteranganFocus = new FocusNode();

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
          _nominalPengajuanController.text = '0';
        } else {
          _nominalPengajuan = int.parse(_nominalPengajuanController.text
              .replaceAll(new RegExp(r"[^\d]"), ''));
        }
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
    });
  }

  void getDataSimpanan() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var _nik = _pref.getString(NIK);
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
    SharedPreferences _pref = await SharedPreferences.getInstance();
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
//    print('Prepare Submit');
//
//    print("Nama Barang : $_namaBarang");
//    Map<String, String> postdata = {
//      "kodeTipePengajuan": _kodeTipePengajuan,
//      "tipePengajuan": _tipePengajuan,
//      "nomorKtp": nomorKtp,
//      "nomorAnggota": nomorAnggota,
//      "nama": nama,
//      "nomorNik": nomorNik,
//      "nomorHp": nomorHp,
//      "kodePerusahaan": kodePerusahaan,
//      "namaPerusahaan": namaPerusahaan,
//      "alamatPerusahaan": alamatPerusahaan,
//      "lokasiPenempatan": lokasiPenempatan,
//      "emailPerusahaan": emailPerusahaan,
//      "tanggalPengajuan": new DateTime.now().toString(),
//      "lamaAngsuran": _lamaAngsuran.toString(),
//      "nominalAngsuran": _nominalAngsuran.toString(),
//      "nominalPengajuan": _nominalPengajuan.toString(),
//      "persenBunga": _persenBunga.toString(),
//      "nominalBunga": _nominalBunga.toString(),
//      "totalBunga": _totalBunga.toString(),
//      "biayaAdmin": _biayaAdmin.toString(),
//      "kodeBarang": _kodeBarang,
//      "namaBarang": _namaBarang,
//      "ambilDariKas": null,
//      "ketKas": null,
//      "keterangan": _keterangan.replaceAll("\n", "\\n"),
//      "statusPengajuan": "NEW",
//      "tanggalPerubahan": null,
//      "tanggalTempo": "15",
//      "tanggalJatuhTempo": "15",
//      "nomorPinjaman": null,
//      "kodeUser": kodeAnggota,
//      "namaUser": nama,
//      "tanggalUpdate": null
//    };
//
//    var client = new http.Client();
//    var dio = Dio();
//
//    SharedPreferences _pref = await SharedPreferences.getInstance();
//
//    var token = _pref.getString(JWT_TOKEN);
//
//    try {
//      setState(() {
//        isLoading = true;
//      });
//
//      if (_keterangan.isEmpty) {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text("Harap isi tujuan pinjaman"),
//        ));
//        return;
//      }
//
//      if (await isRequirementPassed() == false) {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text("Maaf iuran wajib anda kurang dari 6 bulan"),
//        ));
//        return;
//      }
//
//      if (_pref.getString(NAMA_ANGGOTA) == null || _pref.getString(NAMA_ANGGOTA).isEmpty
//          || _pref.getString(NO_KTP) == null || _pref.getString(NO_KTP).isEmpty
//          || _pref.getString(JENIS_KELAMIN) == null || _pref.getString(JENIS_KELAMIN).isEmpty
//          || _pref.getString(TEMPAT_LAHIR) == null || _pref.getString(TEMPAT_LAHIR).isEmpty
//          || _pref.getString(TANGGAL_LAHIR) == null || _pref.getString(TANGGAL_LAHIR).isEmpty
//          || _pref.getString(STATUS_PERKAWINAN) == null || _pref.getString(STATUS_PERKAWINAN).isEmpty
//          || _pref.getString(ALAMAT) == null || _pref.getString(ALAMAT).isEmpty
//          || _pref.getString(PEKERJAAN) == null || _pref.getString(PEKERJAAN).isEmpty
//          || _pref.getString(EMAIL_PRIBADI) == null || _pref.getString(EMAIL_PRIBADI).isEmpty
//          || _pref.getString(CONTACT_ANGGOTA) == null || _pref.getString(CONTACT_ANGGOTA).isEmpty
//          || _pref.getString(NAMA_KONFEDERENSI) == null || _pref.getString(NAMA_KONFEDERENSI).isEmpty
//          || _pref.getString(NAMA_PERUSAHAAN) == null || _pref.getString(NAMA_PERUSAHAAN).isEmpty
//          || _pref.getString(LOKASI_PENEMPATAN) == null || _pref.getString(LOKASI_PENEMPATAN).isEmpty
//          || _pref.getString(NIK) == null || _pref.getString(NIK).isEmpty
//          || _pref.getString(JABATAN_KEANGGOTAAN) == null || _pref.getString(JABATAN_KEANGGOTAAN).isEmpty
//          || _pref.getString(PENDAPATAN) == null || _pref.getString(PENDAPATAN).isEmpty
//          || _pref.getString(NAMA_SAUDARA_DEKAT) == null || _pref.getString(NAMA_SAUDARA_DEKAT).isEmpty
//          || _pref.getString(HUBUNGAN_SAUDARA) == null || _pref.getString(HUBUNGAN_SAUDARA).isEmpty
//          || _pref.getString(ALAMAT_SAUDARA) == null || _pref.getString(ALAMAT_SAUDARA).isEmpty
//          || _pref.getString(NO_HP_SAUDARA) == null || _pref.getString(NO_HP_SAUDARA).isEmpty
//          || _pref.getString(NAMA_BANK) == null || _pref.getString(NAMA_BANK).isEmpty
//          || _pref.getString(NOMOR_REKENING) == null || _pref.getString(NOMOR_REKENING).isEmpty
//          || _pref.getString(SIMPANAN_WAJIB) == null || _pref.getString(SIMPANAN_WAJIB).isEmpty
//          || _pref.getString(CABANG_BANK) == null || _pref.getString(CABANG_BANK).isEmpty || _pref.getString(CABANG_BANK) == "-"
//          || _pref.getString(SIMPANAN_SUKARELA) == null || _pref.getString(SIMPANAN_SUKARELA).isEmpty) {
//
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text("Harap Lengkapi Data Anggota terlebih dahulu."),
//        ));
//        return;
//      }
//
//      String url = "${APIUrl.pengajuan}/post-pengajuan";
//
//      print('Submitting');
//
//      var uriResponse = await dio.post(url,
//          options: Options(headers: {
//            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
//            'jwtToken': token,
//          }),
//          data: jsonEncode(postdata));
//
//      print(uriResponse.statusCode);
//      print(uriResponse.data);
//
//      if (uriResponse.statusCode == 200) {
//        Navigator.of(context).pop();
//        MessageModel value =
//        messageModelFromJson(json.encode(uriResponse.data));
//        Map<String, dynamic> response = jsonDecode(value.data);
//        if (response['success'] == true) {
//          /* _scaffoldKey.currentState.showSnackBar(SnackBar(
//            content: Text("Pengajuan pinjaman berhasil dibuat"),
//          )); */
//          Navigator.pop(context, 'success');
//        }
//      } else {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text("Terjadi kesalahan pada proses pengajuan"),
//        ));
//      }
//    } catch (e) {
//      print('Error detail');
//      print(e);
//      print('End error detail');
//      _scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text("Tidak dapat terhubung dengan server"),
//      ));
//    } finally {
//      setState(() {
//        isLoading = false;
//      });
//      client.close();
//    }
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
//      if (_nominalPengajuan < totalSimpanan) {
//        setState(() {
//          _persenBunga = (8 / 12);
//        });
//      } else if (_nominalPengajuan > totalSimpanan) {
//        setState(() {
//          _persenBunga = 2;
//        });
//      }

      print("ini total simpanan : $totalSimpanan");
      print("ini bagi hasil : $_persenBunga");

      _bunga =
          ((_nominalPengajuan * ((1) / 100)).round() / 100).ceil() *
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
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ajukan Pinjaman Kendaraan"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
              ),
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  //Nominal
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Pilih Kendaraan",
                            style: TextStyle(fontSize: 18.0)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _barang,
                            hint: Text("Silahkan pilih Kendaraan"),
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
                                value: "Tidak ada Kendaraan",
                                child: new Text(
                                  "Tidak ada Kendaraan",
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
                                      _.namaBarang == v)
                                          .keterangan;
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            width: 330.0,
                            child: TextFormField(
                              enabled: false,
                              controller: _keteranganBarangController,
                              maxLines: null,
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 10, left: 10, right: 10),
                    child: TextFormField(
                      controller: _keteranganController,
                      maxLines: null,
                      minLines: 2,
                      focusNode: _keteranganFocus,
                      decoration: InputDecoration(
                        labelText: "Tujuan Pinjaman dan Catatan",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                                min: 11.0,
                                max: 35.0,
                                divisions: 4,
                                onChanged: (v) {
                                  print(v);
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

            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Checkbox(value: _isCheck, onChanged: (bool val) {
                    setState(() {
                      _isCheck = val;
                    });
                  }),
                  Expanded(child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Simulasi diatas hanya contoh perhitungan.",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                              text: " Pengajuan akan ditindahlanjuti oleh Bank ",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.of(context).pushNamed('/ketentuan-kebijakan');
                              }
                          ),
                          TextSpan(
                            text: "yang memfasilitasi kredit diatas.",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]
                    ),
                  ),),
                ],
              ),
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

class Item {
  const Item(this.name);
  final String name;
}
