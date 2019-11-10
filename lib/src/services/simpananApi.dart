import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';

class Simpanan {
  String _idSimpanan;
  String _nomorKtp;
  String _nomorAnggota;
  String _nama;
  String _nomorNik;
  String _nomorHp;
  String _kodePerusahaan;
  String _namaPerusahaan;
  String _alamatPerusahaan;
  String _emailPerusahaan;
  String _kodeSimpanan;
  String _namaSimpanan;
  String _jenisIuran;
  String _ketIuran;
  String _mediaIuran;
  String _bulan;
  String _tahun;
  String _keterangan;
  String _kodeUser;
  String _namaUser;
  DateTime _tanggalSimpanan;
  DateTime _tanggalUpdate;
  int _nominalSimpanan;

  String get idSimpanan =>_idSimpanan;
  String get nomorKtp =>_nomorKtp;
  String get nomorAnggota =>_nomorAnggota;
  String get nama =>_nama;
  String get nomorNik =>_nomorNik;
  String get nomorHp =>_nomorHp;
  String get kodePerusahaan =>_kodePerusahaan;
  String get namaPerusahaan =>_namaPerusahaan;
  String get alamatPerusahaan =>_alamatPerusahaan;
  String get emailPerusahaan =>_emailPerusahaan;
  String get kodeSimpanan =>_kodeSimpanan;
  String get namaSimpanan =>_namaSimpanan;
  String get jenisIuran =>_jenisIuran;
  String get ketIuran =>_ketIuran;
  String get mediaIuran =>_mediaIuran;
  String get bulan =>_bulan;
  String get tahun =>_tahun;
  String get keterangan =>_keterangan;
  String get kodeUser =>_kodeUser;
  String get namaUser =>_namaUser;
  DateTime get tanggalSimpanan =>_tanggalSimpanan;
  DateTime get tanggalUpdate =>_tanggalUpdate;
  int get nominalSimpanan =>_nominalSimpanan;

  String get formattedNominalSimpanan {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_nominalSimpanan);
  }

  String get periodeSimpanan {
    return "$bulan $tahun";
  }

  String get formattedPeriodeSimpanan {
    String formatted = periodeSimpanan;

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

    if(periodeSimpanan.contains(RegExp(r"^\d{2}\s\d{4}"))) {
      List<String> split = periodeSimpanan.split(' ');

      formatted = "${months[int.parse(split[0]) - 1]} ${split[1]}";
    }

    return formatted;
  }

  Simpanan();

  Simpanan.fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    Simpanan.fromMap(m);
  }

  Simpanan.fromMap(Map<String, dynamic> m) {
    _idSimpanan = m['idSimpanan'];
    _nomorKtp = m['nomorKtp'];
    _nomorAnggota = m['nomorAnggota'];
    _nama = m['nama'];
    _nomorNik = m['nomorNik'];
    _nomorHp = m['nomorHp'];
    _kodePerusahaan = m['kodePerusahaan'];
    _namaPerusahaan = m['namaPerusahaan'];
    _alamatPerusahaan = m['alamatPerusahaan'];
    _emailPerusahaan = m['emailPerusahaan'];
    _kodeSimpanan = m['kodeSimpanan'];
    _namaSimpanan = m['namaSimpanan'];
    _jenisIuran = m['jenisIuran'];
    _ketIuran = m['ketIuran'];
    _mediaIuran = m['mediaIuran'];
    _bulan = m['bulan'] != null ? m['bulan'] : '';
    _tahun = m['tahun'] != null ? m['tahun'] : '';
    _keterangan = m['keterangan'];
    _kodeUser = m['kodeUser'];
    _namaUser = m['namaUser'];
    _tanggalSimpanan = parseDate(explodeDate(m['tanggalSimpanan']));
    _tanggalUpdate = parseDate(explodeDate(m['tanggalUpdate']));
    try {
      _nominalSimpanan = double.parse(m['nominalSimpanan']).round();
    } catch(e) {
      _nominalSimpanan = 0;
    }
  }

  Map<String, String> toMap({bool isPengajuanBaru}) {
    if(isPengajuanBaru == null) isPengajuanBaru = false;

    Map<String, String> map = {
      'nomorKtp': _nomorKtp,
      'nomorAnggota': _nomorAnggota,
      'nama': _nama,
      'nomorNik': _nomorNik,
      'nomorHp': _nomorHp,
      'kodePerusahaan': _kodePerusahaan,
      'namaPerusahaan': _namaPerusahaan,
      'alamatPerusahaan': _alamatPerusahaan,
      'emailPerusahaan': _emailPerusahaan,
      'kodeSimpanan': _kodeSimpanan,
      'namaSimpanan': _namaSimpanan,
      'jenisIuran': _jenisIuran,
      'ketIuran': _ketIuran,
      'mediaIuran': _mediaIuran,
      'bulan': _bulan,
      'tahun': _tahun,
      'keterangan': _keterangan,
      'kodeUser': _kodeUser,
      'namaUser': _namaUser,
      'tanggalSimpanan': _tanggalSimpanan.toString(),
      'tanggalUpdate': _tanggalUpdate.toString(),
      'nominalSimpanan': _nominalSimpanan.toString(),
    };

    if(!isPengajuanBaru) map['idSimpanan'] = _idSimpanan;

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
}

class ListSimpanan {
  List<Simpanan> _listSimpanan = [];
  int _totalPokok = 0;
  int _totalWajib = 0;
  int _totalSukarela = 0;
  int _totalSum = 0;

  List<Simpanan> get listSimpanan => _listSimpanan;
  int get totalPokok => _totalPokok;
  int get totalWajib => _totalWajib;
  int get totalSukarela => _totalSukarela;
  int get totalSum => _totalSum;

  String get formattedTotalPokok {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalPokok);
  }

  String get formattedTotalWajib {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalWajib);
  }

  String get formattedTotalSukarela {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalSukarela);
  }

  String get formattedTotalSum {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalSum);
  }

  Future<HttpStatus> getList({@required String nik}) async {
    var client = new http.Client();

    try {
      String url = "${APIUrl.pinjaman}/list-simpanan/$nik";

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
    Map<String, int> d = {
      'wajib': 0,
      'pokok': 0,
      'sukarela': 0,
      'total': 0,
    };

    Map<String, int> k = {
      'wajib': 0,
      'pokok': 0,
      'sukarela': 0,
      'total': 0,
    };

    List<dynamic> m = jsonDecode(json);
    _listSimpanan = [];

    for (Map<String, dynamic> item in m) {
      Simpanan _simpanan = Simpanan.fromMap(item);
      _listSimpanan.add(_simpanan);

      switch(_simpanan.jenisIuran.toLowerCase()) {
        case 'setoran':
          switch (_simpanan.namaSimpanan.toLowerCase()) {
            case 'simpanan wajib':
              d['wajib'] += _simpanan.nominalSimpanan;
              break;
            case 'simpanan pokok':
              d['pokok'] += _simpanan.nominalSimpanan;
              break;
            case 'simpanan sukarela':
              d['sukarela'] += _simpanan.nominalSimpanan;
              break;
          }

          d['total'] += _simpanan.nominalSimpanan;
          break;
        default:
          switch (_simpanan.namaSimpanan.toLowerCase()) {
            case 'simpanan wajib':
              k['wajib'] += _simpanan.nominalSimpanan;
              break;
            case 'simpanan pokok':
              k['pokok'] += _simpanan.nominalSimpanan;
              break;
            case 'simpanan sukarela':
              k['sukarela'] += _simpanan.nominalSimpanan;
              break;
          }

          k['total'] += _simpanan.nominalSimpanan;
          break;
      }
    }

    _totalWajib = d['wajib'] - k['wajib'];
    _totalPokok = d['pokok'] - k['pokok'];
    _totalSukarela = d['sukarela'] - k['sukarela'];
    _totalSum = d['total'] - k['total'];
  }
}
