import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//  Variable checkbox
  bool isPrivacy = false;

  final fullnameCtrl = new TextEditingController();
  final nomorKtpCtrl = new TextEditingController();
  final nomorPonselCtrl = new TextEditingController();
  final emailCtrl = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                children: <Widget>[
                  informasiRegister(),
                  namaLengkapField(),
                  nomorKtpField(),
                  nomorPonselField(),
                  emailField(),
                  acceptPrivacyPoliceField(),
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

      final Email emailTo = Email(
        body:
        'Permohonan Aktivasi Anggota \n\n Nama Lengkap : $namaUser \n Nomor KTP : $nomorKTP \n Nomor HP : $nomorHP \n Email : $email \n\n Mohon dapat diverifikasi account tersebut diatas. Terimakasih',
        subject: 'Aktivasi Anggota',
        recipients: ['cs@kopbi.or.id'],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(emailTo);
        onDialog();
      } catch (error) {
        print(error.toString());
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
              'Terima kasih telah telah melakukan Permohonan Aktivasi Anggota'),
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
}
