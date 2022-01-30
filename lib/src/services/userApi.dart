import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus {
  success, //Berhasil login
  userNotFound, //User ID atau Password salah
  failed, //Tidak diketahui
  serverError, //Tidak dapat berkomunikasi dengan server
  noInternet, //Tidak dapat terhubung ke internet
}

class User {
  String _kodeAnggota;
  String _nomorAnggota;
  String _nama;
  String _nomorKtp;
  String _nomorNik;
  String _jenisKelamin;
  String _tempatLahir;
  String _tanggalLahir;
  String _status;
  String _pekerjaan;
  String _alamat;
  String _nomorHp;
  String _kodePerusahaan;
  String _namaPerusahaan;
  String _alamatPerusahaan;
  String _emailPerusahaan;
  String _lokasiPenempatan;
  String _kodeJabatan;
  String _namaJabatan;
  String _kodeBank;
  String _namaBank;
  String _cabangBank;
  String _nomorRekening;
  String _tanggalRegistrasi;
  String _password;
  String _statusAnggota;
  String _role;
  String _namaKonfederasi;

  String get kodeAnggota => _kodeAnggota != null ? _kodeAnggota : '';
  String get nomorAnggota => _nomorAnggota != null ? _nomorAnggota : '';
  String get nama => _nama != null ? _nama : '';
  String get nomorKtp => _nomorKtp != null ? _nomorKtp : '';
  String get nomorNik => _nomorNik != null ? _nomorNik : '';
  String get jenisKelamin => _jenisKelamin != null ? _jenisKelamin : '';
  String get tempatLahir => _tempatLahir != null ? _tempatLahir : '';
  String get tanggalLahir => _tanggalLahir != null ? _tanggalLahir : '';
  String get status => _status != null ? _status : '';
  String get pekerjaan => _pekerjaan != null ? _pekerjaan : '';
  String get alamat => _alamat != null ? _alamat : '';
  String get nomorHp => _nomorHp != null ? _nomorHp : '';
  String get kodePerusahaan => _kodePerusahaan != null ? _kodePerusahaan : '';
  String get namaPerusahaan => _namaPerusahaan != null ? _namaPerusahaan : '';
  String get alamatPerusahaan => _alamatPerusahaan != null ? _alamatPerusahaan : '';
  String get emailPerusahaan => _emailPerusahaan != null ? _emailPerusahaan : '';
  String get lokasiPenempatan => _lokasiPenempatan != null ? _lokasiPenempatan : '';
  String get kodeJabatan => _kodeJabatan != null ? _kodeJabatan : '';
  String get namaJabatan => _namaJabatan != null ? _namaJabatan : '';
  String get kodeBank => _kodeBank != null ? _kodeBank : '';
  String get namaBank => _namaBank != null ? _namaBank : '';
  String get cabangBank => _cabangBank != null ? _cabangBank : '';
  String get nomorRekening => _nomorRekening != null ? _nomorRekening : '';
  String get tanggalRegistrasi => _tanggalRegistrasi != null ? _tanggalRegistrasi : '';
  String get statusAnggota => _statusAnggota != null ? _statusAnggota : '';
  String get role => _role != null ? _role : '';
  String get namaKonfederasi => _namaKonfederasi != null ? _namaKonfederasi : '';

  String get formattedTanggalLahir {
    String formatted = tanggalLahir;

    if(tanggalLahir.contains(RegExp(r"^\d{4}\-\d{2}\-\d{2}"))) {
      List<String> split = tanggalLahir.split('-');

      formatted = "${split[2]}-${split[1]}-${split[0]}";
    }

    return formatted;
  }

  String get formattedTanggalRegistrasi {
    String formatted = tanggalRegistrasi;

    if(tanggalRegistrasi.contains(RegExp(r"^\d{4}\-\d{2}\-\d{2}"))) {
      List<String> split = tanggalRegistrasi.split('-');

      formatted = "${split[2]}-${split[1]}-${split[0]}";
    }

    return formatted;
  }

  Future<ImageProvider> getProfileImage() async {
    var client = new http.Client();

    try {
      String url = "${APIUrl.images}/anggota/$_nomorNik.jpg";
      print('Image success');

      var uriResponse = await client.get(url);

      if(uriResponse.statusCode != 200) {
        throw "default";
      }

      Uint8List uint8list = uriResponse.bodyBytes;
      saveProfile(uint8list.toString());

      return CachedNetworkImageProvider(url);
    } catch (e) {
      print('Image error');
      print(e.toString());
      return AssetImage('assets/no_user.jpg');
    }
  }

  void saveProfile(String uint8listStr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedProfile', uint8listStr);
    String savedProfile = (prefs.getString('savedProfile') ?? '');
    print("Set Saved Profile: $savedProfile");
  }

  Future<LoginStatus> login({@required String userID, @required String password}) async {
    var client = new http.Client();

    try {
      String url = "${APIUrl.anggota}/login/$userID/$password";

      var uriResponse = await client.post(url);

      if(uriResponse.statusCode == 200 && uriResponse.body.length > 0) {
        String res = uriResponse.body;
        if(res.contains("'")) {
          res = res.replaceAll("'", '"');
        }
        _fromJSON(res);

        if(this._nomorNik != null) {
          saveID(userID);
          return LoginStatus.success;
        } else {
          return LoginStatus.failed;
        }
      } else if(uriResponse.statusCode == 200 && uriResponse.body.length == 0) {
        return LoginStatus.userNotFound;
      } else {
        return LoginStatus.serverError;
      }
    } catch (e) {
      try {
        String url = "http://example.com";

        var uriResponse = await client.get(url);

        if(uriResponse.statusCode != 200) {
          return LoginStatus.failed;
        }

      } catch (ie) {
        print('Error detail');
        print(ie);
        print('End error detail');
        return LoginStatus.noInternet;
      }
    } finally {
      client.close();
    }
  }

  void saveID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedID', userID);
    String savedID = (prefs.getString('savedID') ?? '');
    print("Set Saved ID: $savedID");
  }

  void _fromMap(Map<String, dynamic> m) {
    _kodeAnggota = m['kodeAnggota'];
    _nomorAnggota = m['nomorAnggota'];
    _nama = m['nama'];
    _nomorKtp = m['nomorKtp'];
    _nomorNik = m['nomorNik'];
    _jenisKelamin = m['jenisKelamin'];
    _tempatLahir = m['tempatLahir'];
    _tanggalLahir = m['tanggalLahir'];
    _status = m['status'];
    _pekerjaan = m['pekerjaan'];
    _alamat = m['alamat'];
    _nomorHp = m['nomorHp'];
    _kodePerusahaan = m['kodePerusahaan'];
    _namaPerusahaan = m['namaPerusahaan'];
    _alamatPerusahaan = m['alamatPerusahaan'];
    _emailPerusahaan = m['emailPerusahaan'];
    _lokasiPenempatan = m['lokasiPenempatan'];
    _kodeJabatan = m['kodeJabatan'];
    _namaJabatan = m['namaJabatan'];
    _kodeBank = m['kodeBank'];
    _namaBank = m['namaBank'];
    _cabangBank = m['cabangBank'];
    _nomorRekening = m['nomorRekening'];
    _tanggalRegistrasi = m['tanggalRegistrasi'];
    _password = m['password'];
    _statusAnggota = m['statusAnggota'];
    _role = m['role'];
    _namaKonfederasi = m['namaKonfederasi'];
  }

  void _fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    _fromMap(m);
  }
}