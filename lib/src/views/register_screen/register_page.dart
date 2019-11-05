import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//  Variable checkbox
  bool isPrivacy = false;

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
            Column(
              children: <Widget>[
                informasiRegister(),
                namaLengkapField(),
                nomorKtpField(),
                nomorPonselField(),
                emailField(),
                acceptPrivacyPoliceField(),
              ],
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
        'Terima kasih telah bergabung sebagai anggota KOPBI Indonesia. Lengkapi data probadi andadibawah ini. Kami akan mengirimkan verifikasi data anda melalui SMS / WA / Email yang anda cantumkan dibawah ini.',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget namaLengkapField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Nama Lengkap',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.all(0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget nomorPonselField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Nomor Ponsel',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.all(0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.all(0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget nomorKtpField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'Nomor KTP',
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.all(0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
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
          onPressed: () {},
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
}
