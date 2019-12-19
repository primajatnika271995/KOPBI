import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
//  Variable checkbox
  bool isPrivacy = false;

  final fullnameCtrl = new TextEditingController();
  final nomorKtpCtrl = new TextEditingController();
  final nomorPonselCtrl = new TextEditingController();
  final emailCtrl = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File imageKtp;
  File imageDataDiri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Aktivasi Anggota KOPBI',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  informasiRegister(),
                  namaLengkapField(),
                  nomorKtpField(),
                  nomorPonselField(),
                  emailField(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Text(
                      "Upload Foto KTP dan Foto Diri",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  formPhoto(),
//                  acceptPrivacyPoliceField(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                berikutnyaButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget formPhoto() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: getImageKTP,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
                  image: imageKtp == null
                      ? null
                      : DecorationImage(
                          image: FileImage(imageKtp),
                          fit: BoxFit.cover,
                        ),
                ),
                child: imageKtp == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.file_upload, color: Colors.white),
                            Text(
                              "Upload KTP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: getImageDataDiri,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
                  image: imageDataDiri == null
                      ? null
                      : DecorationImage(
                          image: FileImage(imageDataDiri),
                          fit: BoxFit.cover,
                        ),
                ),
                child: imageDataDiri == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.file_upload, color: Colors.white),
                            Text(
                              "Upload Foto Diri",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget informasiRegister() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Text(
        'Terima kasih telah bergabung sebagai anggota KOPBI Indonesia. Lengkapi data pribadi anda dibawah ini. Kami akan mengirimkan verifikasi data anda melalui SMS / WA / Email yang anda cantumkan dibawah ini.',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget namaLengkapField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        controller: fullnameCtrl,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Nama Lengkap',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Nama tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget nomorPonselField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        controller: nomorPonselCtrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Nomor Ponsel',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Nomor Ponsel tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        controller: emailCtrl,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Email tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget nomorKtpField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        controller: nomorKtpCtrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Nomor KTP',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Nomor KTP tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget acceptPrivacyPoliceField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isPrivacy,
            onChanged: (bool value) {
              setState(() {
                isPrivacy = value;
              });
            },
            activeColor: Colors.green,
          ),
          Container(
            width: 330,
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'Saya setuju dengan',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: ' Syarat & Ketentuan ',
                  style: TextStyle(color: Colors.cyan, fontSize: 13),
                ),
                TextSpan(
                  text: 'dan',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: ' Kebijakan Privasi ',
                  style: TextStyle(color: Colors.cyan, fontSize: 13),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget berikutnyaButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: screenWidth(context),
        child: RaisedButton(
          onPressed: () {
            sendEmail();
          },
          child: Text(
            'SUBMIT',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  void sendEmail() async {
    if (_formKey.currentState.validate()) {
      var namaUser = fullnameCtrl.text;
      var nomorKTP = nomorKtpCtrl.text;
      var nomorHP = nomorPonselCtrl.text;
      var email = emailCtrl.text;

      if (imageKtp == null || imageDataDiri == null) {
        globalKey.currentState.showSnackBar(SnackBar(
          content: Text("Silahkan Upload Foto KTP dan Data Diri"),
        ));
      } else {
        final MailOptions emailTo = MailOptions(
          body:
              'Permohonan Aktivasi Anggota \n\n Nama Lengkap : $namaUser \n Nomor KTP : $nomorKTP \n Nomor HP : $nomorHP \n Email : $email \n\n Mohon dapat diverifikasi account tersebut diatas. Terimakasih',
          subject: 'Aktivasi Anggota',
          recipients: ['cs@kopbi.or.id'],
          attachments: ['${imageKtp.path}', '${imageDataDiri.path}'],
          isHTML: false,
        );

        try {
          await FlutterMailer.send(emailTo);
          onDialog();
        } catch (error) {
          print(error.toString());
        }
      }
    }
  }

  onDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil'),
          content: Text(
              'Terima kasih telah melakukan Permohonan Aktivasi Anggota'),
          actions: <Widget>[
            OutlineButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Call function to Get Image From Camera

  void getImageKTP() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print('Select Camera');

    var rename = await File(image.path).rename(
        '/storage/emulated/0/Android/data/id.or.kopbi.solusi.mobile/files/Pictures/${nomorKtpCtrl.text}_ktp_upload.jpg');

    setState(() {
//      imageKtp = image;

      imageKtp = rename;

//      // Rename File
//      img.Image reImage = img.decodeImage(File(image.path).readAsBytesSync());
//
//      img.Image thumbnail = img.copyResize(reImage, width: 120);
//
//      imageKtp = File('out/thumbnail.png')..writeAsBytesSync(img.encodePng(thumbnail));
//      print(imageKtp.path);
    });
  }

  /// Call function to Get Image From Camera

  void getImageDataDiri() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print('Select Camera');

    var rename = await File(image.path).rename(
        '/storage/emulated/0/Android/data/id.or.kopbi.solusi.mobile/files/Pictures/${nomorKtpCtrl.text}_selfie_upload.jpg');

    setState(() {
      imageDataDiri = rename;
    });
  }
}
