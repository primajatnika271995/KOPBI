import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Barang {
  String _id;
  String _kodeBarang;
  String _namaBarang;
  String _keterangan;
  int _stokBarang;
  int _harga;

  String get id => _id;
  String get kodeBarang => _kodeBarang;
  String get namaBarang => _namaBarang;
  String get keterangan => _keterangan;
  int get stokBarang => _stokBarang;
  int get harga => _harga;

  Barang.fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    Barang.fromMap(m);
  }

  Barang.fromMap(Map<String, dynamic> m) {
    _id = m['id'];
    _kodeBarang = m['kodeBarang'];
    _namaBarang = m['namaBarang'];
    _keterangan = m['keterangan'];
    try {
      _harga = int.parse(m['harga']);
    } catch(e) {
      _harga = 0;
    }
    try {
      _stokBarang = int.parse(m['stokBarang']);
    } catch(e) {
      _stokBarang = 0;
    }
  }
}

class ListBarang {
  List<Barang> _listBarang;
  List<Barang> get listBarang => _listBarang;

  Future<HttpStatus> getList() async {
//    var client = new http.Client();
    var dio = Dio();

    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);

    try {
      String url = "${APIUrl.barang}/list-barang";

      var uriResponse = await dio.post(url, options: Options(
        headers: {
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }
      ), data: {'abc':'d'});

      if(uriResponse.statusCode == 200) {
        MessageModel value = messageModelFromJson(json.encode(uriResponse.data));
        _makeList(value.data);
        return HttpStatus.success;
      } else {
        return HttpStatus.error;
      }
    } catch (e) {
      print('Error detail');
      print(e);
      print('End error detail');
      return HttpStatus.serverError;
    } finally {
      dio.close();
    }
  }

  void _makeList(String json) {
    List<dynamic> m = jsonDecode(json);
    _listBarang = [];

    for (Map<String, dynamic> item in m) {
      _listBarang.add(Barang.fromMap(item));
    }
  }
}
