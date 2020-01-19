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
    _pref.setString(CONTACT_ANGGOTA, value.nomorHp);
    _pref.setString(IMG_PROFILE, urlImg);
    _pref.setString(NIK, value.nomorNik);
    _pref.setString(TGL_REGISTRASI, value.tanggalRegistrasi.toString());
    _pref.setString(PEKERJAAN, value.pekerjaan);
    _pref.setString(TEMPAT_LAHIR, value.tempatLahir);
    _pref.setString(TANGGAL_LAHIR, value.tanggalLahir);
    _pref.setString(ALAMAT, value.alamat);
    _pref.setString(NAMA_PERUSAHAAN, value.namaPerusahaan);
    _pref.setString(ALAMAT_PERUSAHAAN, value.alamatPerusahaan);
    _pref.setString(LOKASI_PENEMPATAN, value.lokasiPenempatan);
    _pref.setString(NAMA_KONFEDERENSI, value.namaKonfederasi);
    _pref.setString(KODE_PERUSAHAAN, value.kodePerusahaan);
    _pref.setString(EMAIL_PERUSAHAAN, value.emailPerusahaan);
    _pref.setString(KODE_USER, value.kodeAnggota);
    _pref.setString(JENIS_KELAMIN, value.jenisKelamin);
    _pref.setString(STATUS, value.status);
    _pref.setString(KODE_JABATAN, value.kodeJabatan);
    _pref.setString(NAMA_JABATAN, value.namaJabatan);
    _pref.setString(KODE_BANK, value.kodeBank);
    _pref.setString(NAMA_BANK, value.namaBank);
    _pref.setString(CABANG_BANK, value.cabangBank);
    _pref.setString(NOMOR_REKENING, value.nomorRekening);
    _pref.setString(PASSWORD, value.password);
    _pref.setString(STATUS_ANGGOTA, value.statusAnggota);
    _pref.setString(ROLE, value.role);
    _pref.setString(EMAIL_PRIBADI, value.emailPribadi);
    _pref.setString(NAMA_SAUDARA_DEKAT, value.namaSaudaraDekat);
    _pref.setString(HUBUNGAN_SAUDARA, value.hubunganSaudara);
    _pref.setString(ALAMAT_SAUDARA, value.alamatSaudara);
    _pref.setString(NO_HP_SAUDARA, value.nomorHpSaudara);
    _pref.setString(NO_KTP, value.nomorKtp);
  }

  dispose() async {
    await _userDetailsFetcher.drain();
    _userDetailsFetcher.close();
  }
}

final loginBloc = LoginBloc();
