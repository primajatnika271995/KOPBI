import 'package:kopbi/src/models/loginResponseModel.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';
import 'package:kopbi/src/services/loginApi.dart';

class LoginRepository {
  final _provider = LoginProvider();

  Future<LoginResponseModel> loginResponse(String userId, String password) => _provider.loginResponse(userId, password);
  Future<UsersDetailsModel> loginAnggota(String userId, String password) => _provider.loginAnggota(userId, password);
}