import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/appVersionModel.dart';
import 'package:kopbi/src/models/loginResponseModel.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';

class LoginProvider {
  Client _client = new Client();
  Dio _dio = new Dio();

  Future<http.Response> appVersion() async {
    final response = await _client.post(
        "http://solusi.kopbi.or.id/api/kopbi-master/list-komponen/INFO_APP");

    if (response.statusCode == 200) {
      return response;
    }
    return null;
  }

  Future<UsersDetailsModel> loginAnggota(String userId, String password) async {
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
    };

    Map body = {
      "userName": userId,
      "password": password,
    };

    final response = await _dio.post(APIUrl.login_anggota,
        options: Options(
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          },
        ),
        data: {
          "userName": userId,
          "password": password,
        });

    if (response.statusCode == 200) {
      return compute(usersDetailsModelFromJson, json.encode(response.data));
    } else if (response.statusCode == 500) {
      print(response.data);
    } else {
      print(response.data);
    }
    return null;
  }

  Future<http.Response> getImageProfile(String nomorAnggota) async {
    final response =
        await _client.get(APIUrl.img_profile + '$nomorAnggota.jpg');
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 406) {
      print("No Acceptable");
    }
    return response;
  }

  Future<http.Response> encryptPassword(String password) async {
    final response = await _client
        .get("https://micro-encrypt.herokuapp.com/encrypt/" + password);

    if (response.statusCode == 200) {
      return response;
    }
    return null;
  }
}
