import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/services/angsuran.dart';
import 'package:kopbi/src/services/pengajuan.dart';
import 'package:kopbi/src/services/update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Im;

class UploadFotoVerifikasi extends StatefulWidget {
  @override
  _UploadFotoVerifikasiState createState() => _UploadFotoVerifikasiState();
}

class _UploadFotoVerifikasiState extends State<UploadFotoVerifikasi> {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: photo == null
                                ? AssetImage('assets/icons/no_user.jpg')
                                : FileImage(photo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 90.0, right: 100.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 25.0,
                          child: new InkWell(
                            onTap: getImage,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
