import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';

class Angsuran {
  String _kodeAngsuran;
  String _nomorPinjaman;
  String _status;
  DateTime _tanggalJatuhTempo;
  int _angsuranKe;
  int _nominalAngsuran;
  int _persenBunga;
  int _biayaAdmin;
  int _totalBayar;
  int _nominalBunga;
  int _totalBunga;

  String get kodeAngsuran => _kodeAngsuran;
  String get nomorPinjaman => _nomorPinjaman;
  String get status => _status;
  DateTime get tanggalJatuhTempo => _tanggalJatuhTempo;
  int get angsuranKe => _angsuranKe;
  int get nominalAngsuran => _nominalAngsuran;
  int get biayaAdmin => _biayaAdmin;
  int get totalBayar => _totalBayar;
  int get persenBunga => _persenBunga;
  int get nominalBunga => _nominalBunga;
  int get totalBunga => _totalBunga;

  String get formattedNominalAngsuran {
    if(_nominalAngsuran == null || _nominalAngsuran.isNaN) return '';
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_nominalAngsuran);
  }

  String get formattedBiayaAdmin {
    if(_biayaAdmin == null || _biayaAdmin.isNaN) return '';
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_biayaAdmin);
  }

  String get formattedTotalBayar {
    if(_totalBayar == null || _totalBayar.isNaN) return '';
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalBayar);
  }

  String get formattedTotalBunga {
    if(_totalBunga == null || _totalBunga.isNaN) return '';
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalBunga);
  }

  Angsuran();

  Angsuran.fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    Angsuran.fromMap(m);
  }

  Angsuran.fromMap(Map<String, dynamic> m) {
    _kodeAngsuran = m['kodeAngsuran'] == null ? '' : m['kodeAngsuran'];
    _nomorPinjaman = m['nomorPinjaman'] == null ? '' : m['nomorPinjaman'];
    _status = m['status'] == null ? '' : m['status'];

    _tanggalJatuhTempo = parseDate(explodeDate(m['tanggalJatuhTempo']));

    _angsuranKe = m['angsuranKe'] == null ? 0 : tryParseInt(m['angsuranKe']);
    _nominalAngsuran = m['nominalAngsuran'] == null ? 0 : tryParseInt(m['nominalAngsuran']);
    _biayaAdmin = m['biayaAdmin'] == null ? 0 : tryParseInt(m['biayaAdmin']);
    _totalBayar = m['totalBayar'] == null ? 0 : tryParseInt(m['totalBayar']);
    _persenBunga = m['persenBunga'] == null ? 0 : tryParseInt(m['persenBunga']);

    _nominalBunga = m['nominalBunga'] == null ? 0 : tryParseInt(m['nominalBunga']);
    _totalBunga = m['totalBunga'] == null ? 0 : tryParseInt(m['totalBunga']);
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

  Map<String, String> toMap() {
    Map<String, String> map = {
      'kodeAngsuran': _kodeAngsuran,
      'nomorPinjaman': _nomorPinjaman,
      'status': _status,
      'tanggalJatuhTempo': _tanggalJatuhTempo.toString(),
      'angsuranKe': _angsuranKe.toString(),
      'nominalAngsuran': _nominalAngsuran.toString(),
      'persenBunga': _persenBunga.toString(),
      'biayaAdmin': _biayaAdmin.toString(),
      'totalBayar': _totalBayar.toString(),
      'nominalBunga': _nominalBunga.toString(),
      'totalBunga': _totalBunga.toString(),
    };

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
      //map['millisecond'] = int.parse(millisecond);
      map['millisecond'] = 0;
    }

    return map;
  }

  DateTime parseDate(Map<String, int> map) {
    if(map == null) return null;

    return new DateTime(map['year'], map['month'], map['date'], map['hour'], map['minute'], map['second']);
  }
}

class ListAngsuran {
  List<Angsuran> _listAngsuran = [];
  int _total = 0;
  int _totalPaid = 0;

  List<Angsuran> get listAngsuran => _listAngsuran;
  int get total => _total;
  int get totalPaid => _totalPaid;

  String get formattedTotal {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_total);
  }

  String get formattedTotalPaid {
    var f = new NumberFormat.currency(locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);
    return f.format(_totalPaid);
  }

  Future<HttpStatus> getList({@required String nomorPinjaman}) async {
    var client = new http.Client();

    try {
      String url = "${APIUrl.pinjaman}/list-angsuran/$nomorPinjaman";

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
    _listAngsuran = [];

    for (Map<String, dynamic> item in m) {
      Angsuran angsuran = Angsuran.fromMap(item);

      _total += angsuran.totalBayar;

      if(angsuran.status.toLowerCase() == 'paid') _totalPaid += angsuran.totalBayar;

      _listAngsuran.add(angsuran);
    }
  }
}