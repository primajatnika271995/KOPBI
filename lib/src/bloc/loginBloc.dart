import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/loginResponseModel.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';
import 'package:kopbi/src/repository/loginRepository.dart';
import 'package:kopbi/src/views/component/flushbar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final _repository = LoginRepository();
  final _userDetailsFetcher = PublishSubject<UsersDetailsModel>();

  Observable<UsersDetailsModel> get streamUserDetails =>
      _userDetailsFetcher.stream;

  login(BuildContext context, String userId, String password) async {
    LoginResponseModel msg = await _repository.loginResponse(userId, password);

    if (msg.message != null) {
      print(msg.message);
      flushBar(context, "User ID tidak terdaftar", 3);
    } else {
      UsersDetailsModel value = await _repository.loginAnggota(userId, password);
      getImageProfile(context, value.nomorAnggota, value);
    }
  }

  getImageProfile(BuildContext context, String nomorAnggota, UsersDetailsModel value) {
    _repository.getImageProfile(nomorAnggota).then((response) {
      if (response.statusCode == 200) {
        String urlImage = '${APIUrl.img_profile}$nomorAnggota.jpg';
        setPreferences(value, urlImage);
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setPreferences(value, null);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  setPreferences(UsersDetailsModel value, String urlImg) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString(NOMOR_ANGGOTA, value.nomorAnggota);
    _pref.setString(NAMA_ANGGOTA, value.nama);
    _pref.setString(IMG_PROFILE, urlImg);
  }

  dispose() async {
    await _userDetailsFetcher.drain();
    _userDetailsFetcher.close();
  }
}

final loginBloc = LoginBloc();
