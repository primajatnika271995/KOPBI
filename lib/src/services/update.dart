import 'dart:io';

import 'package:dio/dio.dart';
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
}