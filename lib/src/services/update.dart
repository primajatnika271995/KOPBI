import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateService {
  Dio dio = new Dio();

  Future<Response> updateFoto(File image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var nomorAnggota = pref.getString(NOMOR_ANGGOTA);
    var token = pref.getString(JWT_TOKEN);

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path,
          filename: "$nomorAnggota.jpg"),
    });

    return await dio.post(
        "http://solusi.kopbi.or.id/api/kobi-images/upload/anggota/$nomorAnggota",
        options: Options(headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }),
        data: formData);
  }

  Future<Response> verifikasiFoto(File image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var nomorAnggota = pref.getString(NOMOR_ANGGOTA);
    var token = pref.getString(JWT_TOKEN);

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path,
          filename: "1.jpg"),
    });

    return await dio.post(
        "http://solusi.kopbi.or.id/api/kobi-images/upload/pengajuan/1",
        options: Options(headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        }),
        data: formData);
  }

  Future<Response> updatePassword(String oldPassword, String newPassword) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString(JWT_TOKEN);
    var userId = _pref.getString(CONTACT_ANGGOTA);

    final response = await dio.post(
      "http://solusi.kopbi.or.id/api/kopbi-agt/change-password",
      options: Options(
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
          'jwtToken': token,
        },
      ),
      data: {
        "userName": userId,
        "oldPassword": oldPassword,
        "password": newPassword,
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 500) {
      print(response.data);
    } else {
      print(response.data);
    }
    return null;
  }

//  Future<Response> updatePassword(String passwordBaru) async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
//
//    print("${"kodeAnggota " + pref.getString(KODE_USER)}");
//    print("${"nomorAnggota " + pref.getString(NOMOR_ANGGOTA)}");
//    print("${"nama " + pref.getString(NAMA_ANGGOTA)}");
//    print("${"nomorKtp " + pref.getString(NO_KTP)}");
//    print("${"nomorNik " + pref.getString(NIK)}");
//    print("${"jenisKelamin " + pref.getString(JENIS_KELAMIN)}");
//    print("${"tempatLahir " + pref.getString(TEMPAT_LAHIR)}");
//    print("${"tanggalLahir " + pref.getString(TANGGAL_LAHIR)}");
//    print("${"status " + pref.getString(STATUS)}");
//    print("${"pekerjaan " + pref.getString(PEKERJAAN)}");
//    print("${"alamat " + pref.getString(ALAMAT)}");
//    print("${"nomorHp " + pref.getString(CONTACT_ANGGOTA)}");
//    print("${"kodePerusahaan " + pref.getString(KODE_PERUSAHAAN)}");
//    print("${"namaPerusahaan " + pref.getString(NAMA_PERUSAHAAN)}");
//    print("${"alamatPerusahaan " + pref.getString(ALAMAT_PERUSAHAAN)}");
//    print("${"emailPerusahaan " + pref.getString(EMAIL_PERUSAHAAN)}");
//    print("${"lokasiPenempatan " + pref.getString(LOKASI_PENEMPATAN)}");
//    print("${"kodeJabatan " + pref.getString(KODE_JABATAN)}");
//    print("${"namaJabatan " + pref.getString(NAMA_JABATAN)}");
//    print("${"kodeBank " + pref.getString(KODE_BANK)}");
//    print("${"namaBank " + pref.getString(NAMA_BANK)}");
//    print("${"cabangBank " + pref.getString(CABANG_BANK)}");
//    print("${"nomorRekening " + pref.getString(NOMOR_REKENING)}");
//    print("${"tanggalRegistrasi " + pref.getString(TGL_REGISTRASI)}");
//    print("${"password " + passwordBaru}");
//    print("${"statusAnggota " + pref.getString(STATUS_ANGGOTA)}");
//    print("${"role " + pref.getString(ROLE)}");
//    print("${"namaKonfederasi " + pref.getString(NAMA_KONFEDERENSI)}");
//    print("${"emailPribadi " + pref.getString(EMAIL_PRIBADI)}");
//    print("${"namaSaudaraDekat " + pref.getString(NAMA_SAUDARA_DEKAT)}");
//    print("${"hubunganSaudara " + pref.getString(HUBUNGAN_SAUDARA)}");
//    print("${"alamatSaudara " + pref.getString(ALAMAT_SAUDARA)}");
//    print("${"nomorHpSaudara " + pref.getString(NO_HP_SAUDARA)}");
//    print("${"pendapatan " + pref.getString(PENDAPATAN)}");
//    print("${"simpananWajib " + pref.getString(SIMPANAN_WAJIB)}");
//    print("${"simpananSukarela " + pref.getString(SIMPANAN_SUKARELA)}");
//    print("${"jabatanAnggota " + pref.getString(JABATAN_KEANGGOTAAN)}");
//
//    Map body = {
//      "kodeAnggota": pref.getString(KODE_USER),
//      "nomorAnggota": pref.getString(NOMOR_ANGGOTA),
//      "nama": pref.getString(NAMA_ANGGOTA),
//      "nomorKtp": pref.getString(NO_KTP),
//      "nomorNik": pref.getString(NIK),
//      "jenisKelamin": pref.getString(JENIS_KELAMIN),
//      "tempatLahir": pref.getString(TEMPAT_LAHIR),
//      "tanggalLahir": pref.getString(TANGGAL_LAHIR),
//      "status": pref.getString(STATUS),
//      "pekerjaan": pref.getString(PEKERJAAN),
//      "alamat": pref.getString(ALAMAT),
//      "nomorHp": pref.getString(CONTACT_ANGGOTA),
//      "kodePerusahaan": pref.getString(KODE_PERUSAHAAN),
//      "namaPerusahaan": pref.getString(NAMA_PERUSAHAAN),
//      "alamatPerusahaan": pref.getString(ALAMAT_PERUSAHAAN),
//      "emailPerusahaan": pref.getString(EMAIL_PERUSAHAAN),
//      "lokasiPenempatan": pref.getString(LOKASI_PENEMPATAN),
//      "kodeJabatan": pref.getString(KODE_JABATAN),
//      "namaJabatan": pref.getString(NAMA_JABATAN),
//      "kodeBank": pref.getString(KODE_BANK),
//      "namaBank": pref.getString(NAMA_BANK),
//      "cabangBank": pref.getString(CABANG_BANK),
//      "nomorRekening": pref.getString(NOMOR_REKENING),
//      "tanggalRegistrasi": pref.getString(TGL_REGISTRASI),
//      "password": passwordBaru,
//      "statusAnggota": pref.getString(STATUS_ANGGOTA),
//      "role": pref.getString(ROLE),
//      "namaKonfederasi": pref.getString(NAMA_KONFEDERENSI),
//      "emailPribadi": pref.getString(EMAIL_PRIBADI),
//      "namaSaudaraDekat": pref.getString(NAMA_SAUDARA_DEKAT),
//      "hubunganSaudara": pref.getString(HUBUNGAN_SAUDARA),
//      "alamatSaudara": pref.getString(ALAMAT_SAUDARA),
//      "nomorHpSaudara": pref.getString(NO_HP_SAUDARA),
//      "pendapatan": pref.getString(PENDAPATAN),
//      "simpananWajib": pref.getString(SIMPANAN_WAJIB),
//      "simpananSukarela": pref.getString(SIMPANAN_SUKARELA),
//      "jabatanKeanggotaan": pref.getString(JABATAN_KEANGGOTAAN)
//    };
//
//    var token = pref.getString(JWT_TOKEN);
//
//    return await dio.post("http://solusi.kopbi.or.id/api/kopbi-agt/post-anggota",
//      options: Options(headers: {
//        'Content-type': 'application/x-www-form-urlencoded',
//        'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
//        'jwtToken': token,
//      }),
//      data: body,
//    );
//  }
}
