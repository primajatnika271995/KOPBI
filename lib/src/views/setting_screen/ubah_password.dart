import 'package:flutter/material.dart';

class UbahPasswordScreen extends StatefulWidget {
  @override
  _UbahPasswordScreenState createState() => _UbahPasswordScreenState();
}

class _UbahPasswordScreenState extends State<UbahPasswordScreen> {
  var passwordLamaCtrl = new TextEditingController();
  var passwordBaruCtrl = new TextEditingController();
  var passwordBaruConfirmCtrl = new TextEditingController();

  bool passwordLamaObs = true;
  bool passwordBaruObs = true;
  bool passwordConfObs = true;

  void toggleLama() {
    setState(() {
      passwordLamaObs = !passwordLamaObs;
    });
  }

  void toggleConf() {
    setState(() {
      passwordConfObs = !passwordConfObs;
    });
  }

  void toggleBaru() {
    setState(() {
      passwordBaruObs = !passwordBaruObs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Ubah Password',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password Lama',
                hasFloatingPlaceholder: true,
                suffixIcon: InkWell(
                  onTap: toggleLama,
                  child: Icon(passwordLamaObs
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              obscureText: passwordLamaObs,
              controller: passwordLamaCtrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password Baru',
                hasFloatingPlaceholder: true,
                suffixIcon: InkWell(
                  onTap: toggleBaru,
                  child: Icon(passwordBaruObs
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              obscureText: passwordBaruObs,
              controller: passwordBaruCtrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Ulangi Password Baru',
                hasFloatingPlaceholder: true,
                suffixIcon: InkWell(
                  onTap: toggleConf,
                  child: Icon(passwordConfObs
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              obscureText: passwordConfObs,
              controller: passwordBaruConfirmCtrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {},
                color: Colors.green,
                child: Text(
                  'Simpan Perubahan',
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
