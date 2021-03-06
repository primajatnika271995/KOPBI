import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/config/urls.dart';
import 'package:kopbi/src/models/loginResponseModel.dart';
import 'package:kopbi/src/models/usersDetailsModel.dart';
import 'package:kopbi/src/repository/loginRepository.dart';
import 'package:kopbi/src/views/component/flushbar.dart';
import 'package:kopbi/src/views/setting_screen/ubah_password.dart';
import 'package:kopbi/src/views/setting_screen/ubah_password_awal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final _repository = LoginRepository();
  final _userDetailsFetcher = PublishSubject<UsersDetailsModel>();

  Observable<UsersDetailsModel> get streamUserDetails => _userDetailsFetcher.stream;

  login(BuildContext context, String userId, String password) async {
      UsersDetailsModel value = await _repository.loginAnggota(userId, password);

      if (!value.success) {
        flushBar(context, "Nomor Handphone atau Password salah!", 3);
      }

      if (value.success) {
        getImageProfile(context, value.data.user.nomorAnggota, value);
      }

  }

  getImageProfile(BuildContext context, String nomorAnggota, UsersDetailsModel value) async {
    var pref = await SharedPreferences.getInstance();

    _repository.getImageProfile(nomorAnggota).then((response) {
      if (response.statusCode == 200) {
        print("ADA IMAGE");
        String urlImage = '${APIUrl.img_profile}$nomorAnggota.jpg';
        setPreferences(value, urlImage);

        if (pref.getString(DECRYPT_PASSWORD) == "123456") {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => UbahPasswordAwalScreen(),
            ), (Route<dynamic> route) => false
          );
        } else {
//          Navigator.of(context).pushReplacementNamed('/home');
          Navigator.of(context).pushReplacementNamed('/bottom-bar');
        }
      } else {
        print("GA ADA IMAGE");
        setPreferences(value, null);
        if (pref.getString(DECRYPT_PASSWORD) == "123456") {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => UbahPasswordAwalScreen(),
            ), (Route<dynamic> route) => false
          );
        } else {
//          Navigator.of(context).pushReplacementNamed('/home');
          Navigator.of(context).pushReplacementNamed('/bottom-bar');
        }
      }
    });
  }

  setPreferences(UsersDetailsModel value, String urlImg) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString(JWT_TOKEN, value.data.session.jwt);
    
    print("NO HP SAUDARA : ${value.data.user.nomorHpSaudara}");

    _pref.setString(NOMOR_ANGGOTA, value.data.user.nomorAnggota);
    _pref.setString(NAMA_ANGGOTA, value.data.user.nama);
    _pref.setString(CONTACT_ANGGOTA, value.data.user.nomorHp);
    _pref.setString(IMG_PROFILE, urlImg);
    _pref.setString(NIK, value.data.user.nomorNik);
    _pref.setString(TGL_REGISTRASI, value.data.user.tanggalRegistrasi.toString());
    _pref.setString(PEKERJAAN, value.data.user.pekerjaan);
    _pref.setString(TEMPAT_LAHIR, value.data.user.tempatLahir);
    _pref.setString(TANGGAL_LAHIR, value.data.user.tanggalLahir);
    _pref.setString(ALAMAT, value.data.user.alamat);
    _pref.setString(NAMA_PERUSAHAAN, value.data.user.namaPerusahaan);
    _pref.setString(ALAMAT_PERUSAHAAN, value.data.user.alamatPerusahaan);
    _pref.setString(LOKASI_PENEMPATAN, value.data.user.lokasiPenempatan);
    _pref.setString(NAMA_KONFEDERENSI, value.data.user.namaKonfederasi);
    _pref.setString(KODE_FEDERASI, value.data.user.kodeKonfederasi);
    _pref.setString(KODE_PERUSAHAAN, value.data.user.kodePerusahaan);
    _pref.setString(EMAIL_PERUSAHAAN, value.data.user.emailPerusahaan);
    _pref.setString(KODE_USER, value.data.user.kodeAnggota);
    _pref.setString(JENIS_KELAMIN, value.data.user.jenisKelamin);
    _pref.setString(STATUS, value.data.user.status);
    _pref.setString(KODE_JABATAN, value.data.user.kodeJabatan);
    _pref.setString(NAMA_JABATAN, value.data.user.namaJabatan);
    _pref.setString(KODE_BANK, value.data.user.kodeBank);
    _pref.setString(NAMA_BANK, value.data.user.namaBank);
    _pref.setString(CABANG_BANK, value.data.user.cabangBank);
    _pref.setString(NOMOR_REKENING, value.data.user.nomorRekening);
    _pref.setString(PASSWORD, value.data.user.password);
    _pref.setString(STATUS_ANGGOTA, value.data.user.statusAnggota);
    _pref.setString(ROLE, value.data.user.role);
    _pref.setString(EMAIL_PRIBADI, value.data.user.emailPribadi);
    _pref.setString(NAMA_SAUDARA_DEKAT, value.data.user.namaSaudaraDekat);
    _pref.setString(HUBUNGAN_SAUDARA, value.data.user.hubunganSaudara);
    _pref.setString(ALAMAT_SAUDARA, value.data.user.alamatSaudara);
    _pref.setString(NO_HP_SAUDARA, value.data.user.nomorHpSaudara);
    _pref.setString(NO_KTP, value.data.user.nomorKtp);
    _pref.setString(PENDAPATAN, value.data.user.pendapatan);
    _pref.setString(SIMPANAN_WAJIB, value.data.user.simpananWajib);
    _pref.setString(SIMPANAN_SUKARELA, value.data.user.simpananSukarela);
    _pref.setString(JABATAN_KEANGGOTAAN, value.data.user.jabatanKeanggotaan);
    _pref.setString(STATUS_PERKAWINAN, value.data.user.status);

    print("NAMA SAUDRA + ${value.data.user.namaSaudaraDekat}");

    if (value.data.user.nama.isEmpty || value.data.user.nama == "-" ||
    value.data.user.nomorAnggota.isEmpty || value.data.user.nomorAnggota == "-" ||
    value.data.user.jenisKelamin.isEmpty || value.data.user.jenisKelamin == "-" ||
    value.data.user.tempatLahir == "-" || value.data.user.tanggalLahir.isEmpty || value.data.user.tanggalLahir == "-" ||
    value.data.user.status == "-" || value.data.user.alamat.isEmpty || value.data.user.alamat == "-" ||
    value.data.user.pekerjaan == "-" || value.data.user.emailPribadi == "-" || value.data.user.nomorHp.isEmpty || value.data.user.nomorHp == "-" ||
    value.data.user.namaKonfederasi.isEmpty || value.data.user.namaKonfederasi == "-" ||
    value.data.user.namaPerusahaan.isEmpty || value.data.user.namaPerusahaan == "-" ||
    value.data.user.lokasiPenempatan == "-" || value.data.user.lokasiPenempatan == "" || value.data.user.nomorNik.isEmpty || value.data.user.nomorNik == "-" ||
    value.data.user.jabatanKeanggotaan == "-" || value.data.user.jabatanKeanggotaan == "" || value.data.user.pendapatan == "=" || value.data.user.pendapatan == "" ||
    value.data.user.namaSaudaraDekat == "-" || value.data.user.namaSaudaraDekat == "" || value.data.user.hubunganSaudara == "-" || value.data.user.hubunganSaudara == "" ||
    value.data.user.alamatSaudara == "-" || value.data.user.alamatSaudara ==  "" || value.data.user.nomorHpSaudara == "-" || value.data.user.nomorHpSaudara == "" ||
    value.data.user.namaBank == "-" || value.data.user.namaBank == "" || value.data.user.cabangBank == "-" || value.data.user.cabangBank == "" ||
    value.data.user.nomorRekening == "-" || value.data.user.nomorRekening == "" || value.data.user.simpananWajib == 0.0) {

      _pref.setBool(COMPLETIONDATA, false);

    } else {

      _pref.setBool(COMPLETIONDATA, true);
    }

    _pref.setBool(SHOW_IKLAN, true);
  }

  dispose() async {
    await _userDetailsFetcher.drain();
    _userDetailsFetcher.close();
  }
}

final loginBloc = LoginBloc();
