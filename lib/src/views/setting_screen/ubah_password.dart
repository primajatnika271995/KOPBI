import 'package:flutter/material.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/encrypt_model.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/services/update.dart';
import 'package:kopbi/src/views/component/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String old;

  bool isLoading = false;

  String encriptOldPassword;
  String encriptNewPassword;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

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

  void getOldPassword() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString(DECRYPT_PASSWORD));

    setState(() {
      old = _pref.getString(DECRYPT_PASSWORD);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getOldPassword();
    super.initState();
  }

  void updatePassword() async {
    if (passwordBaruCtrl.text != passwordBaruConfirmCtrl.text) {
      print("Password Tidak Sama");
      flushBar(context, "Password tidak sama!", 3);
    } else if (passwordBaruCtrl.text.isEmpty) {
      print("Password Tidak boleh kosong");
    } else if (old != passwordLamaCtrl.text) {
      flushBar(context, "Password Lama anda tidak sama!", 3);
    } else {
      toggleLoading();
      UpdateService service = new UpdateService();
      LoginProvider encript = new LoginProvider();

      await encript.encryptPassword(passwordLamaCtrl.text).then((response) async {
        if (response.statusCode == 200) {
          var valueOld = encryptModelFromJson(response.body);
          setState(() {
            encriptOldPassword = valueOld.response;
          });
          await encript.encryptPassword(passwordBaruCtrl.text).then((resp) async {
            var valueNew = encryptModelFromJson(resp.body);
            setState(() {
              encriptNewPassword = valueNew.response;
            });
            await service.updatePassword(encriptOldPassword, encriptNewPassword).then((response) async {
              print("Update Password Response : ${response.statusCode}");
              SharedPreferences _pref = await SharedPreferences.getInstance();
              if (response.statusCode == 200) {
                toggleLoading();
                _pref.clear();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            });
          });
        }
      });

    }
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
                onPressed: isLoading ? null : updatePassword,
                color: Colors.green,
                child: Text(
                  isLoading ? 'Waiting...' : 'Simpan Perubahan',
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
