import 'package:kopbi/src/models/usersDetailsModel.dart';
import 'package:kopbi/src/services/loginApi.dart';

class LoginRepository {
  final _provider = LoginProvider();

  Future<UsersDetailsModel> login(String userId, String password) => _provider.loginAnggota(userId, password);
}