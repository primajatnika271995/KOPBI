import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/services/userApi.dart';

class Pinjaman {
  String _kodePinjaman;
  String _nomorPinjaman;
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
  String _statusPinjaman;
  String _kodeUser;
  String _namaUser;
  DateTime _tanggalPengajuan;
  DateTime _tanggalPerubahan;
  DateTime _tanggalTempo;
  DateTime _tanggalJatuhTempo;
  DateTime _tanggalUpdate;
  int _lamaAngsuran;
  int _angsuranKe;
  int _nominalAngsuran;
  int _sisaAngsuran;
  int _persenBunga;
  int _biayaAdmin;
  int _nominalPinjaman;
  int _sisaPinjaman;
  double _nominalBunga;
  double _totalBunga;

  String get kodePinjaman => _kodePinjaman;
  String get nomorPinjaman => _nomorPinjaman;
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
  String get statusPinjaman => _statusPinjaman;
  String get kodeUser => _kodeUser;
  String get namaUser => _namaUser;
  DateTime get tanggalPengajuan => _tanggalPengajuan;
  DateTime get tanggalPerubahan => _tanggalPerubahan;
  DateTime get tanggalTempo => _tanggalTempo;
  DateTime get tanggalJatuhTempo => _tanggalJatuhTempo;
  DateTime get tanggalUpdate => _tanggalUpdate;
  int get lamaAngsuran => _lamaAngsuran;
  int get angsuranKe => _angsuranKe;
  int get nominalAngsuran => _nominalAngsuran;
  int get sisaAngsuran => _sisaAngsuran;
  int get persenBunga => _persenBunga;
  int get biayaAdmin => _biayaAdmin;
  int get nominalPinjaman => _nominalPinjaman;
  int get sisaPinjaman => _sisaPinjaman;
  double get nominalBunga => _nominalBunga;
  double get totalBunga => _totalBunga;

  String get formattedNominalAngsuran {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_nominalAngsuran);
  }

  String get formattedNominalPinjaman {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_nominalPinjaman);
  }

  Pinjaman();

  Pinjaman.fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    Pinjaman.fromMap(m);
  }

  Pinjaman.fromMap(Map<String, dynamic> m) {
    _kodePinjaman = m['kodePinjaman'];
    _nomorPinjaman = m['nomorPinjaman'];
    _kodeTipePengajuan = m['kodeTipePengajuan'];
    _tipePengajuan = m['tipePengajuan'];
    _nomorKtp = m['nomorKtp'];
    _nomorAnggota = m['nomorAnggota'];
    _nama = m['nama'];
    _nomorNik = m['nomorNik'];
    _nomorHp = m['nomorHp'];
    _kodePerusahaan = m['kodePerusahaan'];
    _namaPerusahaan = m['namaPerusahaan'];
    _alamatPerusahaan = m['alamatPerusahaan'];
    _emailPerusahaan = m['emailPerusahaan'];
    _kodeBarang = m['kodeBarang'];
    _namaBarang = m['namaBarang'];
    _ambilDariKas = m['ambilDariKas'];
    _ketKas = m['ketKas'];
    _keterangan = m['keterangan'];
    _statusPinjaman = m['statusPinjaman'];
    _sisaPinjaman = m['sisaPinjaman'];
    _angsuranKe = m['angsuranKe'];
    _sisaAngsuran = m['sisaAngsuran'];
    _kodeUser = m['kodeUser'];
    _namaUser = m['namaUser'];
    _tanggalPengajuan = parseDate(explodeDate(m['tanggalPengajuan']));
    _tanggalPerubahan = parseDate(explodeDate(m['tanggalPerubahan']));
    _tanggalTempo = parseDate(explodeDate(m['tanggalTempo']));
    _tanggalJatuhTempo = parseDate(explodeDate(m['tanggalJatuhTempo']));
    _tanggalUpdate = parseDate(explodeDate(m['tanggalUpdate']));
    _lamaAngsuran = tryParseInt(m['lamaAngsuran']);
    _nominalAngsuran = tryParseInt(m['nominalAngsuran']);
    _persenBunga = tryParseInt(m['persenBunga']);
    _biayaAdmin = tryParseInt(m['biayaAdmin']);
    _nominalPinjaman = tryParseInt(m['nominalPinjaman']);
    _nominalBunga = tryParseDouble(m['nominalBunga']);
    _totalBunga = tryParseDouble(m['totalBunga']);
  }

  int tryParseInt(source) {
    try {
      return double.parse(source).round();
    } catch (e) {
      return 0;
    }
  }

  double tryParseDouble(source) {
    try {
      return double.parse(source);
    } catch (e) {
      return 0;
    }
  }

  Map<String, String> toMap({bool isPinjamanBaru}) {
    if(isPinjamanBaru == null) isPinjamanBaru = false;

    Map<String, String> map = {
      'nomorPinjaman': _nomorPinjaman,
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
      'statusPinjaman': _statusPinjaman,
      'kodeUser': _kodeUser,
      'namaUser': _namaUser,
      'tanggalPengajuan': _tanggalPengajuan.toString(),
      'tanggalPerubahan': _tanggalPerubahan.toString(),
      'tanggalTempo': _tanggalTempo.toString(),
      'tanggalJatuhTempo': _tanggalJatuhTempo.toString(),
      'tanggalUpdate': _tanggalUpdate.toString(),
      'lamaAngsuran': _lamaAngsuran.toString(),
      'angsuranKe': _angsuranKe.toString(),
      'nominalAngsuran': _nominalAngsuran.toString(),
      'sisaAngsuran': _sisaAngsuran.toString(),
      'persenBunga': _persenBunga.toString(),
      'biayaAdmin': _biayaAdmin.toString(),
      'nominalPinjaman': _nominalPinjaman.toString(),
      'sisaPinjaman': _sisaPinjaman.toString(),
      'nominalBunga': _nominalBunga.toString(),
      'totalBunga': _totalBunga.toString(),
    };

    if(!isPinjamanBaru) map['kodePinjaman'] = _kodePinjaman;

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

  Future<HttpStatus> submitPengajuanBaru({@required User user}) async {
    var client = new http.Client();

    Map<String, String> postData = this.toMap(isPinjamanBaru: true);

    Map<String, String> userData = {
      "nomorKtp": user.nomorKtp,
      "nomorAnggota": user.nomorAnggota,
      "nama": user.nama,
      "nomorNik": user.nomorNik,
      "nomorHp": user.nomorHp,
      "kodePerusahaan": user.kodePerusahaan,
      "namaPerusahaan": user.namaPerusahaan,
      "alamatPerusahaan": user.alamatPerusahaan,
      "emailPerusahaan": user.emailPerusahaan,
      "kodeUser": user.kodeAnggota,
      "namaUser": user.nama,
    };

    userData.keys.forEach((k) => postData[k] = userData[k]);

    try {
      String url = "${APIUrl.pengajuan}/post-pengajuan";

      var uriResponse = await client.post(url, body: {postData});

      if(uriResponse.statusCode == 200) {
        Map<String, dynamic> response = jsonDecode(uriResponse.body);
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
      client.close();
    }
  }
}

class ListPinjaman {
  List<Pinjaman> _listPinjaman = [];
  int _total = 0;

  List<Pinjaman> get listPinjaman => _listPinjaman;
  int get total =>_total;

  String get formattedTotal {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_total);
  }

  Future<HttpStatus> getList({@required String nik}) async {
    var client = new http.Client();

    try {
      String url = "${APIUrl.pinjaman}/list-pinjaman/$nik";

      var uriResponse = await client.post(url);

      if(uriResponse.statusCode == 200 && uriResponse.body.length > 0) {
        _makeList(uriResponse.body);
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
      client.close();
    }
  }

  void _makeList(String json) {
    List<dynamic> m = jsonDecode(json);
    _listPinjaman = [];

    for (Map<String, dynamic> item in m) {
      Pinjaman pinjaman = Pinjaman.fromMap(item);
      _total += (pinjaman.nominalAngsuran * pinjaman.lamaAngsuran);
      _listPinjaman.add(pinjaman);
    }
  }
}