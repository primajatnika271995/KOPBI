import 'package:flutter/material.dart';
import 'package:kopbi/src/models/encrypt_model.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/services/update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahPasswordAwalScreen extends StatefulWidget {
  @override
  _UbahPasswordAwalScreenState createState() => _UbahPasswordAwalScreenState();
}

class _UbahPasswordAwalScreenState extends State<UbahPasswordAwalScreen> {
  var passwordLamaCtrl = new TextEditingController();
  var passwordBaruCtrl = new TextEditingController();
  var passwordBaruConfirmCtrl = new TextEditingController();

  bool passwordLamaObs = true;
  bool passwordBaruObs = true;
  bool passwordConfObs = true;

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

  void updatePassword() async {
    if (passwordBaruCtrl.text != passwordBaruConfirmCtrl.text) {
      print("Password Tidak Sama");
    } else if (passwordBaruCtrl.text.isEmpty) {
      print("Password Tidak boleh kosong");
    } else {
      toggleLoading();
      UpdateService service = new UpdateService();
      LoginProvider encript = new LoginProvider();

      await encript.encryptPassword("123456").then((response) async {
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Text(
          'Ubah Default Password',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//            child: TextField(
//              decoration: InputDecoration(
//                labelText: 'Password Lama',
//                hasFloatingPlaceholder: true,
//                suffixIcon: InkWell(
//                  onTap: toggleLama,
//                  child: Icon(passwordLamaObs
//                      ? Icons.visibility
//                      : Icons.visibility_off),
//                ),
//              ),
//              obscureText: passwordLamaObs,
//              controller: passwordLamaCtrl,
//            ),
//          ),
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
