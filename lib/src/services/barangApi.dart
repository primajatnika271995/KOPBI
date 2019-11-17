import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';

class Barang {
  String _id;
  String _kodeBarang;
  String _namaBarang;
  int _harga;

  String get id => _id;
  String get kodeBarang => _kodeBarang;
  String get namaBarang => _namaBarang;
  int get harga => _harga;

  Barang.fromJSON(String json) {
    Map<String, dynamic> m = jsonDecode(json);

    Barang.fromMap(m);
  }

  Barang.fromMap(Map<String, dynamic> m) {
    _id = m['id'];
    _kodeBarang = m['kodeBarang'];
    _namaBarang = m['namaBarang'];
    try {
      _harga = int.parse(m['harga']);
    } catch(e) {
      _harga = 0;
    }
  }
}

class ListBarang {
  List<Barang> _listBarang;

  List<Barang> get listBarang => _listBarang;

  Future<HttpStatus> getList() async {
    var client = new http.Client();

    try {
      String url = "${APIUrl.barang}/list-barang";

      var uriResponse = await client.post(url, body: {'abc':'d'});

      if(uriResponse.statusCode == 200 && uriResponse.body.length > 0) {
        _makeList(uriResponse.body);
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
      client.close();
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
