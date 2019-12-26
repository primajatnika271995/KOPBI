import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/appVersionModel.dart';
import 'package:kopbi/src/models/loginResponseModel.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';

class LoginProvider {
  Client _client = new Client();

  Future<LoginResponseModel> loginResponse(String userId, String password) async {
    final response = await _client.post(APIUrl.login_anggota + '$userId/$password');
    if (response.statusCode == 200 && response.body.length > 0) {
      String res = response.body;

      if(res.contains("'")) {
        res = res.replaceAll("'", '"');
      }

      return compute(loginResponseModelFromJson, res);
    }
    return null;
  }
  
  Future<http.Response> appVersion() async {
    final response = await _client.post("http://solusi.kopbi.or.id/api/kopbi-master/list-komponen/INFO_APP");

    if (response.statusCode == 200) {
      return response;
    }
    return null;
  }

  Future<UsersDetailsModel> loginAnggota(String userId, String password) async {
    final response = await _client.post(APIUrl.login_anggota + '$userId/$password');
    if (response.statusCode == 200 && response.body.length > 0) {
      return compute(usersDetailsModelFromJson, response.body);
    }
    return null;
  }
  
  Future<http.Response> getImageProfile(String nomorAnggota) async {
    final response = await _client.get(APIUrl.img_profile + '$nomorAnggota.jpg');
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 406) {
      print("No Acceptable");
    } return response;
  }
}
