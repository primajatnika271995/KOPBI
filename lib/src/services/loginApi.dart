import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';

class LoginProvider {
  Client _client = new Client();

  Future<UsersDetailsModel> loginAnggota(String userId, String password) async {
    final response = await _client.post(APIUrl.login_anggota + '$userId/$password');
    if (response.statusCode == 200 && response.body.length > 0) {
      return compute(usersDetailsModelFromJson, response.body);
    }
    return null;
  }
}
