import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/services/angsuran.dart';
import 'package:kopbi/src/services/pengajuan.dart';
import 'package:kopbi/src/services/update.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Im;

class UploadFotoVerifikasiKredit extends StatefulWidget {
  @override
  _UploadFotoVerifikasiKreditState createState() => _UploadFotoVerifikasiKreditState();
}

class _UploadFotoVerifikasiKreditState extends State<UploadFotoVerifikasiKredit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File photo;
  String nomorAnggota;

  bool isLoading = false;

  String kodePengjuan;

  ListPengajuan _dbPengajuan;
  List<Pengajuan> _listPengajuan;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void getNomorAnggota() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nomorAnggota = pref.getString(NIK);
    });

    await _dbPengajuan.getList(nik: nomorAnggota);
    _listPengajuan = _dbPengajuan.listPengajuan;

    print(_listPengajuan.last.kodePengajuan);
    setState(() {
      kodePengjuan = _listPengajuan.last.kodePengajuan;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    var rename = await File(image.path).rename(
//        '/storage/emulated/0/Android/data/id.or.kopbi.solusi.mobile/files/Pictures/$nomorAnggota.jpg');

    Im.Image compres = Im.decodeImage(image.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(compres, width: 300, height: 400); // choose the size here, it will maintain aspect ratio


    var newim2 = new File('/storage/emulated/0/Android/data/id.or.kopbi.solusi.mobile/files/Pictures/$kodePengjuan.jpg')
      ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));

    setState(() {
      photo = newim2;
    });
  }

  void postUpdate() async {
    if (photo == null) {
      print("Foto Tidak boleh kosong");
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Foto Tidak boleh kosong'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      UpdateService service = new UpdateService();
      toggleLoading();
      await service.verifikasiFoto(photo, kodePengjuan).then((response) async {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        if (response.statusCode == 200) {
          toggleLoading();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (response.statusCode == 500) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('Error 500'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getNomorAnggota();
    _listPengajuan = [];
    _dbPengajuan = ListPengajuan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Upload Foto',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                Container(
                  width: screenWidth(context),
                  height: 200.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      image: photo == null
                          ? NetworkImage('https://sman2babelan.sch.id/assets/icon/ionicons-2.0.1/png/512/upload.png')
                          : FileImage(photo),
                      fit: photo == null ? BoxFit.contain : BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 25.0,
                      child: new InkWell(
                        onTap: getImage,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Text("*Silahkan upload foto yang mendukung pengajuan anda.", style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.justify,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: isLoading ? null : postUpdate,
                color: Colors.green,
                child: Text(
                  isLoading ? 'Waiting Upload' : 'Upload Foto',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
