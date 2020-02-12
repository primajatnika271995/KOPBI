import 'package:kopbi/src/models/loginResponseModel.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final _provider = LoginProvider();
  Future<UsersDetailsModel> loginAnggota(String userId, String password) => _provider.loginAnggota(userId, password);
  Future<http.Response> getImageProfile(String nomorAnggota) => _provider.getImageProfile(nomorAnggota);
}