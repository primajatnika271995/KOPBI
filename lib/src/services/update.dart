import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:kopbi/src/config/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateService {
  Dio dio = new Dio();

  Future<Response> updateFoto(File image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var nomorAnggota = pref.getString(NOMOR_ANGGOTA);
    FormData formData = FormData.from({
      "file": await UploadFileInfo(new File(image.path), "$nomorAnggota.jpg")
    });

    return await dio.post("http://solusi.kopbi.or.id/api/kobi-images/upload/anggota/$nomorAnggota.jpg", data: formData);
  }

  Future<http.Response> updatePassword(String passwordBaru) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    print("${"kodeAnggota " + pref.getString(KODE_USER)}");
    print("${"nomorAnggota " + pref.getString(NOMOR_ANGGOTA)}");
    print("${"nama " + pref.getString(NAMA_ANGGOTA)}");
    print("${"nomorKtp " + pref.getString(NO_KTP)}");
    print("${"nomorNik " + pref.getString(NIK)}");
    print("${"jenisKelamin " + pref.getString(JENIS_KELAMIN)}");
    print("${"tempatLahir " + pref.getString(TEMPAT_LAHIR)}");
    print("${"tanggalLahir " + pref.getString(TANGGAL_LAHIR)}");
    print("${"status " + pref.getString(STATUS)}");
    print("${"pekerjaan " + pref.getString(PEKERJAAN)}");
    print("${"alamat " + pref.getString(ALAMAT)}");
    print("${"nomorHp " + pref.getString(CONTACT_ANGGOTA)}");
    print("${"kodePerusahaan " + pref.getString(KODE_PERUSAHAAN)}");
    print("${"namaPerusahaan " + pref.getString(NAMA_PERUSAHAAN)}");
    print("${"alamatPerusahaan " + pref.getString(ALAMAT_PERUSAHAAN)}");
    print("${"emailPerusahaan " + pref.getString(EMAIL_PERUSAHAAN)}");
    print("${"lokasiPenempatan " + pref.getString(LOKASI_PENEMPATAN)}");
    print("${"kodeJabatan " + pref.getString(KODE_JABATAN)}");
    print("${"namaJabatan " + pref.getString(NAMA_JABATAN)}");
    print("${"kodeBank " + pref.getString(KODE_BANK)}");
    print("${"namaBank " + pref.getString(NAMA_BANK)}");
    print("${"cabangBank " + pref.getString(CABANG_BANK)}");
    print("${"nomorRekening " + pref.getString(NOMOR_REKENING)}");
    print("${"tanggalRegistrasi " + pref.getString(TGL_REGISTRASI)}");
    print("${"password " + passwordBaru}");
    print("${"statusAnggota " + pref.getString(STATUS_ANGGOTA)}");
    print("${"role " + pref.getString(ROLE)}");
    print("${"namaKonfederasi " + pref.getString(NAMA_KONFEDERENSI)}");
    print("${"emailPribadi " + pref.getString(EMAIL_PRIBADI)}");
    print("${"namaSaudaraDekat " + pref.getString(NAMA_SAUDARA_DEKAT)}");
    print("${"hubunganSaudara " + pref.getString(HUBUNGAN_SAUDARA)}");
    print("${"alamatSaudara " + pref.getString(ALAMAT_SAUDARA)}");
    print("${"nomorHpSaudara " + pref.getString(NO_HP_SAUDARA)}");

    Map body = {
      "kodeAnggota": pref.getString(KODE_USER),
      "nomorAnggota": pref.getString(NOMOR_ANGGOTA),
      "nama": pref.getString(NAMA_ANGGOTA),
      "nomorKtp": pref.getString(NO_KTP),
      "nomorNik": pref.getString(NIK),
      "jenisKelamin": pref.getString(JENIS_KELAMIN),
      "tempatLahir": pref.getString(TEMPAT_LAHIR),
      "tanggalLahir": pref.getString(TANGGAL_LAHIR),
      "status": pref.getString(STATUS),
      "pekerjaan": pref.getString(PEKERJAAN),
      "alamat": pref.getString(ALAMAT),
      "nomorHp": pref.getString(CONTACT_ANGGOTA),
      "kodePerusahaan": pref.getString(KODE_PERUSAHAAN),
      "namaPerusahaan": pref.getString(NAMA_PERUSAHAAN),
      "alamatPerusahaan": pref.getString(ALAMAT_PERUSAHAAN),
      "emailPerusahaan": pref.getString(EMAIL_PERUSAHAAN),
      "lokasiPenempatan": pref.getString(LOKASI_PENEMPATAN),
      "kodeJabatan": pref.getString(KODE_JABATAN),
      "namaJabatan": pref.getString(NAMA_JABATAN),
      "kodeBank": pref.getString(KODE_BANK),
      "namaBank": pref.getString(NAMA_BANK),
      "cabangBank": pref.getString(CABANG_BANK),
      "nomorRekening": pref.getString(NOMOR_REKENING),
      "tanggalRegistrasi": pref.getString(TGL_REGISTRASI),
      "password": passwordBaru,
      "statusAnggota": pref.getString(STATUS_ANGGOTA),
      "role": pref.getString(ROLE),
      "namaKonfederasi": pref.getString(NAMA_KONFEDERENSI),
      "emailPribadi": pref.getString(EMAIL_PRIBADI),
      "namaSaudaraDekat": pref.getString(NAMA_SAUDARA_DEKAT),
      "hubunganSaudara": pref.getString(HUBUNGAN_SAUDARA),
      "alamatSaudara": pref.getString(ALAMAT_SAUDARA),
      "nomorHpSaudara": pref.getString(NO_HP_SAUDARA),
      "pendapatan": "",
      "simpananWajib": "",
      "simpananSukarela": "",
      "jabatanKeanggotaan": ""
    };

    return await http.post("http://solusi.kopbi.or.id/api/kopbi-agt/post-anggota", body: json.encode(body), headers: headers);
  }
}