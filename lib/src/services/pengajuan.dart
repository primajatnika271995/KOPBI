import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengajuan {
  String _kodePengajuan;
  String _kodeTipePengajuan;
  String _tipePengajuan;
  String _nomorKtp;
  String _nomorAnggota;
  String _nama;
  String _nomorNik;
  String _nomorHp;
  String _kodePerusahaan;
  String _namaPerusahaan;
  String _alamatPerusahaan;
  String _emailPerusahaan;
  String _kodeBarang;
  String _namaBarang;
  String _ambilDariKas;
  String _ketKas;
  String _keterangan;
  String _statusPengajuan;
  String _nomorPinjaman;
  String _kodeUser;
  String _namaUser;
  String _tanggalTempo;
  String _tanggalJatuhTempoRaw;
  String _tanggalPengajuanRaw;
  String _tanggalPerubahanRaw;
  String _tanggalUpdateRaw;
  String _namaUserHRD;
  String _catatanHRD;
  String _namaUserPengawas;
  String _catatanPengawas;
  String _kategoriPengajuan;
  DateTime _tanggalJatuhTempo;
  DateTime _tanggalPengajuan;
  DateTime _tanggalPerubahan;
  DateTime _tanggalAppHRD;
  DateTime _tanggalAppPengawas;
  DateTime _tanggalUpdate;
  int _lamaAngsuran;
  int _nominalAngsuran;
  int _nominalPengajuan;
  int _simpananPokok;
  int _simpananWajib;
  int _simpananSukarela;
  int _persenBunga;
  int _nominalBunga;
  int _totalBunga;
  int _biayaAdmin;

  String get kodePengajuan => _kodePengajuan;
  String get kodeTipePengajuan => _kodeTipePengajuan;
  String get tipePengajuan => _tipePengajuan;
  String get nomorKtp => _nomorKtp;
  String get nomorAnggota => _nomorAnggota;
  String get nama => _nama;
  String get nomorNik => _nomorNik;
  String get nomorHp => _nomorHp;
  String get kodePerusahaan => _kodePerusahaan;
  String get namaPerusahaan => _namaPerusahaan;
  String get alamatPerusahaan => _alamatPerusahaan;
  String get emailPerusahaan => _emailPerusahaan;
  String get kodeBarang => _kodeBarang;
  String get namaBarang => _namaBarang;
  String get ambilDariKas => _ambilDariKas;
  String get ketKas => _ketKas;
  String get keterangan => _keterangan;
  String get statusPengajuan => _statusPengajuan;
  String get nomorPinjaman => _nomorPinjaman;
  String get kodeUser => _kodeUser;
  String get namaUser => _namaUser;
  String get namaUserHRD => _namaUserHRD;
  String get catatanHRD => _catatanHRD;
  String get namaUserPengawas => _namaUserPengawas;
  String get catatanPengawas => _catatanPengawas;
  String get tanggalTempo => _tanggalTempo;
  String get tanggalJatuhTempoRaw => _tanggalJatuhTempoRaw;
  String get tanggalPengajuanRaw => _tanggalPengajuanRaw;
  String get tanggalPerubahanRaw => _tanggalPerubahanRaw;
  String get tanggalUpdateRaw => _tanggalUpdateRaw;
  String get kategoriPengajuan => _kategoriPengajuan;
  DateTime get tanggalJatuhTempo => _tanggalJatuhTempo;
  DateTime get tanggalPengajuan => _tanggalPengajuan;
  DateTime get tanggalPerubahan => _tanggalPerubahan;
  DateTime get tanggalAppHRD => _tanggalAppHRD;
  DateTime get tanggalAppPengawas => _tanggalAppPengawas;
  DateTime get tanggalUpdate => _tanggalUpdate;
  int get lamaAngsuran => _lamaAngsuran;
  int get nominalAngsuran => _nominalAngsuran;
  int get simpananPokok => _simpananPokok;
  int get simpananWajib => _simpananWajib;
  int get simpananSukarela => _simpananSukarela;
  int get nominalPengajuan => _nominalPengajuan;
  int get persenBunga => _persenBunga;
  int get nominalBunga => _nominalBunga;
  int get totalBunga => _totalBunga;
  int get biayaAdmin => _biayaAdmin;

  String get formattedNominalAngsuran {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_nominalAngsuran);
  }

  String get formattedNominalPengajuan {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_nominalPengajuan);
  }

  Pengajuan();

  Pengajuan.fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    Pengajuan.fromMap(m);
  }

  Pengajuan.fromMap(Map<String, dynamic> m) {
    _kodePengajuan = m['kodePengajuan'] == null ? '' : m['kodePengajuan'];
    _kodeTipePengajuan = m['kodeTipePengajuan'] == null ? '' : m['kodeTipePengajuan'];
    _tipePengajuan = m['tipePengajuan'] == null ? '' : m['tipePengajuan'];
    _nomorKtp = m['nomorKtp'] == null ? '' : m['nomorKtp'];
    _nomorAnggota = m['nomorAnggota'] == null ? '' : m['nomorAnggota'];
    _nama = m['nama'] == null ? '' : m['nama'];
    _nomorNik = m['nomorNik'] == null ? '' : m['nomorNik'];
    _nomorHp = m['nomorHp'] == null ? '' : m['nomorHp'];
    _kodePerusahaan = m['kodePerusahaan'] == null ? '' : m['kodePerusahaan'];
    _namaPerusahaan = m['namaPerusahaan'] == null ? '' : m['namaPerusahaan'];
    _alamatPerusahaan = m['alamatPerusahaan'] == null ? '' : m['alamatPerusahaan'];
    _emailPerusahaan = m['emailPerusahaan'] == null ? '' : m['emailPerusahaan'];
    _kodeBarang = m['kodeBarang'] == null ? '' : m['kodeBarang'];
    _namaBarang = m['namaBarang'] == null ? '' : m['namaBarang'];
    _ambilDariKas = m['ambilDariKas'] == null ? '' : m['ambilDariKas'];
    _ketKas = m['ketKas'] == null ? '' : m['ketKas'];
    _keterangan = m['keterangan'] == null ? '' : m['keterangan'];
    _statusPengajuan = m['statusPengajuan'] == null ? '' : m['statusPengajuan'];
    _nomorPinjaman = m['nomorPinjaman'] == null ? '' : m['nomorPinjaman'];
    _kodeUser = m['kodeUser'] == null ? '' : m['kodeUser'];
    _namaUser = m['namaUser'] == null ? '' : m['namaUser'];
    _namaUser = m['namaUser'];
    _namaUserHRD = m['namaUserHRD'];
    _catatanHRD = m['catatanHRD'];
    _namaUserPengawas = m['namaUserPengawas'];
    _catatanPengawas = m['catatanPengawas'];
    _kategoriPengajuan = m['kategoriPengajuan'];
    _simpananPokok = tryParseInt(m['simpananPokok']);
    _simpananWajib = tryParseInt(m['simpananWajib']);
    _simpananSukarela = tryParseInt(m['simpananSukarela']);
    _tanggalTempo = m['tanggalTempo'] == null ? '' : m['tanggalTempo'];
    _tanggalJatuhTempoRaw = m['tanggalJatuhTempo'] == null ? '' : m['tanggalJatuhTempo'];
    _tanggalPengajuanRaw = m['tanggalPengajuan'] == null ? '' : m['tanggalPengajuan'];
    _tanggalPerubahanRaw = m['tanggalPerubahan'] == null ? '' : m['tanggalPerubahan'];
    _tanggalUpdateRaw = m['tanggalUpdate'] == null ? '' : m['tanggalUpdate'];
    _tanggalJatuhTempo = m['tanggalJatuhTempo'] == null ? null : parseDate(explodeDate(m['tanggalJatuhTempo']));
    _tanggalPengajuan = m['tanggalPengajuan'] == null ? null : parseDate(explodeDate(m['tanggalPengajuan']));
    _tanggalPerubahan = m['tanggalPerubahan'] == null ? null : parseDate(explodeDate(m['tanggalPerubahan']));
    _tanggalUpdate = m['tanggalUpdate'] == null ? null : parseDate(explodeDate(m['tanggalUpdate']));
    _tanggalAppHRD = parseDate(explodeDate(m['tanggalAppHRD']));
    _tanggalAppPengawas = parseDate(explodeDate(m['tanggalAppPengawas']));
    _lamaAngsuran = m['lamaAngsuran'] == null ? 0 : tryParseInt(m['lamaAngsuran']);
    _nominalAngsuran = m['nominalAngsuran'] == null ? 0 : tryParseInt(m['nominalAngsuran']);
    _nominalPengajuan = m['nominalPengajuan'] == null ? 0 : tryParseInt(m['nominalPengajuan']);
    _persenBunga = m['persenBunga'] == null ? 0 : tryParseInt(m['persenBunga']);
    _nominalBunga = m['nominalBunga'] == null ? 0 : tryParseInt(m['nominalBunga']);
    _totalBunga = m['totalBunga'] == null ? 0 : tryParseInt(m['totalBunga']);
    _biayaAdmin = m['biayaAdmin'] == null ? 0 : tryParseInt(m['biayaAdmin']);
  }

  int tryParseInt(source) {
    try {
      return double.parse(source).round();
    } catch (e) {
      return 0;
    }
  }

  Map<String, String> toMap({bool isPengajuanBaru}) {
    if(isPengajuanBaru == null) isPengajuanBaru = false;

    Map<String, String> map = {
      'kodeTipePengajuan': _kodeTipePengajuan,
      'tipePengajuan': _tipePengajuan,
      'nomorKtp': _nomorKtp,
      'nomorAnggota': _nomorAnggota,
      'nama': _nama,
      'nomorNik': _nomorNik,
      'nomorHp': _nomorHp,
      'kodePerusahaan': _kodePerusahaan,
      'namaPerusahaan': _namaPerusahaan,
      'alamatPerusahaan': _alamatPerusahaan,
      'emailPerusahaan': _emailPerusahaan,
      'kodeBarang': _kodeBarang,
      'namaBarang': _namaBarang,
      'ambilDariKas': _ambilDariKas,
      'ketKas': _ketKas,
      'keterangan': _keterangan,
      'statusPengajuan': _statusPengajuan,
      'nomorPinjaman': _nomorPinjaman,
      'kodeUser': _kodeUser,
      'namaUser': _namaUser,
      'namaUserHRD': _namaUserHRD,
      'catatanHRD': _catatanHRD,
      'namaUserPengawas': _namaUserPengawas,
      'catatanPengawas': _catatanPengawas,
      'tanggalTempo': _tanggalTempo,
      'kategoriPengajuan': _kategoriPengajuan,
      'tanggalJatuhTempo': _tanggalJatuhTempo.toString(),
      'tanggalPengajuan': _tanggalPengajuan.toString(),
      'tanggalPerubahan': _tanggalPerubahan.toString(),
      'tanggalUpdate': _tanggalUpdate.toString(),
      'tanggalAppHRD': _tanggalAppHRD.toString(),
      'tanggalAppPengawas': _tanggalAppPengawas.toString(),
      'lamaAngsuran': _lamaAngsuran.toString(),
      'nominalAngsuran': _nominalAngsuran.toString(),
      'nominalPengajuan': _nominalPengajuan.toString(),
      'persenBunga': _persenBunga.toString(),
      'nominalBunga': _nominalBunga.toString(),
      'totalBunga': _totalBunga.toString(),
      'simpananPokok': _simpananPokok.toString(),
      'simpananWajib': _simpananWajib.toString(),
      'simpananSukarela': _simpananSukarela.toString(),
      'biayaAdmin': _biayaAdmin.toString(),
    };

    if(!isPengajuanBaru) map['kodePengajuan'] = _kodePengajuan;

    return map;
  }

  Map<String, int> explodeDate(String dateStr) {
    if(dateStr == null || dateStr.length < 13) return null;

    String year = dateStr.substring(0, 4);
    String month = dateStr.substring(5, 7);
    String date = dateStr.substring(8, 10);
    String hour = dateStr.substring(11, 13);
    String minute = dateStr.substring(14, 16);
    String second = dateStr.substring(17, 19);

    Map<String, int> map = {
      'year': int.parse(year),
      'month': int.parse(month),
      'date': int.parse(date),
      'hour': int.parse(hour),
      'minute': int.parse(minute),
      'second': int.parse(second),
      'millisecond': 0,
    };

    if(dateStr.length > 20) {
      String millisecond = dateStr.substring(20).replaceAll(new RegExp(r"[^\d]"), '');
      map['millisecond'] = int.parse(millisecond);
    }

    return map;
  }

  DateTime parseDate(Map<String, int> map) {
    if(map == null) return null;

    return new DateTime(map['year'], map['month'], map['date'], map['hour'], map['minute'], map['second']);
  }

  Future<HttpStatus> submitPengajuanBaru() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var nomorKtp = _pref.getString(NO_KTP);
    var nomorAnggota  = _pref.getString(NOMOR_ANGGOTA);
    var nama = _pref.getString(NAMA_ANGGOTA);
    var nomorNIK = _pref.getString(NIK);
    var nomorHP = _pref.getString(CONTACT_ANGGOTA);
    var kodePerusahaan = _pref.getString(KODE_PERUSAHAAN);
    var namaPerusahaan = _pref.getString(NAMA_PERUSAHAAN);
    var lokasiPenempatan = _pref.getString(LOKASI_PENEMPATAN);
    var alamatPerusahaan = _pref.getString(ALAMAT_PERUSAHAAN);
    var emailPerusahaan = _pref.getString(EMAIL_PERUSAHAAN);
    var kodeUser = _pref.getString(KODE_USER);


//    var client = new http.Client();
    var dio = Dio();

    var token = _pref.getString(JWT_TOKEN);

    Map<String, String> postData = this.toMap(isPengajuanBaru: true);

    Map<String, String> userData = {
      "nomorKtp": nomorKtp,
      "nomorAnggota": nomorAnggota,
      "nama": nama,
      "nomorNik": nomorNIK,
      "nomorHp": nomorHP,
      "kodePerusahaan": kodePerusahaan,
      "namaPerusahaan": namaPerusahaan,
      "lokasiPenempatan": lokasiPenempatan,
      "alamatPerusahaan": alamatPerusahaan,
      "emailPerusahaan": emailPerusahaan,
      "kodeUser": kodeUser,
      "namaUser": nama,
    };

    userData.keys.forEach((k) => postData[k] = userData[k]);

    try {
      String url = "${APIUrl.pengajuan}/post-pengajuan";

      var uriResponse = await dio.post(url, options: Options(
        headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }
      ), data: postData);

      if(uriResponse.statusCode == 200) {
        MessageModel value = messageModelFromJson(json.encode(uriResponse.data));
        Map<String, dynamic> response = jsonDecode(value.data);
        if(response['success'] == true) {
          return HttpStatus.success;
        }
      }

      return HttpStatus.error;
    } catch (e) {
      print('Error detail');
      print(e);
      print('End error detail');
      return HttpStatus.serverError;
    } finally {
      dio.close();
    }
  }
}

class ListPengajuan {
  List<Pengajuan> _listPengajuan = [];
  int _total = 0;

  List<Pengajuan> get listPengajuan => _listPengajuan;
  int get total =>_total;

  String get formattedTotal {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_total);
  }

  Future<HttpStatus> getList({@required String nik}) async {
//    var client = new http.Client();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var token = _pref.getString(JWT_TOKEN);
    var dio = Dio();

    try {
      String url = "${APIUrl.pengajuan}/list-pengajuan/$nik";

      var uriResponse = await dio.post(url, options: Options(
        headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }
      ),);

      if(uriResponse.statusCode == 200) {
        MessageModel value = messageModelFromJson(json.encode(uriResponse.data));
        _makeList(value.data);
        return HttpStatus.success;
      } else {
        return HttpStatus.serverError;
      }
    } catch (e) {
      print('Error detail');
      print(e);
      print('End error detail');
      return HttpStatus.error;
    } finally {
      dio.close();
    }
  }

  void _makeList(String json) {
    List<dynamic> m = jsonDecode(json);
    _listPengajuan = [];

    for (Map<String, dynamic> item in m) {
      _listPengajuan.add(Pengajuan.fromMap(item));
    }
  }
}