import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewRegisterPage extends StatefulWidget {
  @override
  _NewRegisterPageState createState() => _NewRegisterPageState();
}

class _NewRegisterPageState extends State<NewRegisterPage> {
  final globalKey = GlobalKey<ScaffoldState>();

  final nomorKtpCtrl = new TextEditingController();
  final nomorNIKCtrl = new TextEditingController();
  final nomorHpCtrl = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void onSubmited() async {
    SharedPreferences value = await SharedPreferences.getInstance();
    var token = value.getString(JWT_TOKEN);

    Dio _dio = new Dio();
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      var response = await _dio.post(
          "http://solusi.kopbi.or.id/api/kopbi-agt/aktifasi",
          options: Options(headers: {
            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
            'Content-Type': 'application/json'
          }),
          data: {
            "nomorNik": nomorNIKCtrl.text,
            "nomorKtp": nomorKtpCtrl.text,
            "nomorHp": nomorHpCtrl.text
          });

      if (response.statusCode == 200) {
        if (response.data["success"] == false) {
          setState(() {
            isLoading = false;
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Data Tidak Cocok'),
                content: Container(
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "Data anda belum terdaftar sebagai anggota KOPBI Indonesia, Silahkan hubungi Admin KOPBI di"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Kantor Sekretariat",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                          "Jalan Wika No. 52 Srengsengsawah Jagakarsa - Jakarta Selatan"),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Telpon 021. 29120134\nWhatsapp 0859 2003 4045"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }

        if (response.data["success"] == true) {
          setState(() {
            isLoading = false;
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Berhasil'),
                content: Container(
                  height: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "Selamat anda telah berhasil melakukan aktivasi."),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Silahkan login menggunakan Nomor HP anda dan password 123456"),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Rubah secara berkala password anda dan Update data anggota anda pada menu pengaturan untuk dapat melakukan transaksi pengajuan pinjaman."),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Terima Kasih"),
                    ],
                  ),
                ),
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
    }
  }

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
                  nomorKTPField(),
                  nomorNIKField(),
                  nomorPonselField(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                isLoading
                    ? Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : berikutnyaButton(),
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
        'Terima kasih telah bergabung sebagai anggota KOPBI Indonesia. Lengkapi data pribadi anda dibawah ini. Kami akan memverifikasi data yang anda cantumkan dibawah ini.',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget nomorPonselField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        controller: nomorHpCtrl,
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

  Widget nomorKTPField() {
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

  Widget nomorNIKField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextFormField(
        controller: nomorNIKCtrl,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          labelText: 'NIK',
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
            return 'NIK tidak boleh kosong';
          }
          return null;
        },
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
            onSubmited();
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
}
