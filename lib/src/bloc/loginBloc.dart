import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';
import 'package:kopbi/src/repository/loginRepository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final _repository = LoginRepository();
  final _userDetailsFetcher = PublishSubject<UsersDetailsModel>();

  Observable<UsersDetailsModel> get streamUserDetails =>
      _userDetailsFetcher.stream;

  login(String userId, String password) async {
    UsersDetailsModel value = await _repository.login(userId, password);

    if (value != null) {
      print(value.nomorAnggota);
      print(value.nama);

      setPreferences(value);
    } else  {
      print('Data tidak terdaftar');
    }
  }

  setPreferences(UsersDetailsModel value) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString(NOMOR_ANGGOTA, value.nomorAnggota);
    _pref.setString(NAMA_ANGGOTA, value.nama);
  }

  dispose() async {
    await _userDetailsFetcher.drain();
    _userDetailsFetcher.close();
  }
}

final loginBloc = LoginBloc();

