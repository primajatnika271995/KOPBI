import 'package:flutter/material.dart';
import 'package:kopbi/src/bloc/loginBloc.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/encrypt_model.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReLoginScreen extends StatefulWidget {
  @override
  _ReLoginScreenState createState() => _ReLoginScreenState();
}

class _ReLoginScreenState extends State<ReLoginScreen> {
//  Variable Temp
  String _idAnggota;
  String _imgProfile;
  String _contactAnggota;

  //  Varible boolean
  bool obsecurePassword = true;
  bool _isLoading = false;

//  Text Controller
  final _passCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.green[600],
                  Colors.green[400],
                  Colors.green[400],
                  Colors.green[300],
                ],
              ),
            ),
            height: screenHeight(context),
          ),
          Container(
            width: screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                avatarContent(),
                idField(),
                passwordField(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    width: screenWidth(context),
                    child: RaisedButton(
                      onPressed: loginService,
                      color: Colors.red,
                      child: _isLoading
                          ? Text(
                        'Mohon tunggu ...',
                        style: TextStyle(color: Colors.white),
                      )
                          : Text(
                        'MASUK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Text(
                'Masukan Security Code Anda',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                child: OutlineButton(
                  onPressed: navLogout,
                  child: Text(
                    'PINDAH KE AKUN LAIN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget avatarContent() {
    return CircleAvatar(
      backgroundImage: _imgProfile == null
          ? AssetImage('assets/icons/no_user.jpg')
          : NetworkImage(_imgProfile),
      backgroundColor: Colors.white,
      radius: 50,
    );
  }

  Widget idField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        '$_idAnggota',
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 15),
      child: TextFormField(
          controller: _passCtrl,
          style: TextStyle(color: Colors.white),
          obscureText: obsecurePassword,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.white),
            suffixIcon: InkWell(
              onTap: toggleObscure,
              child: Icon(
                  obsecurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white),
            ),
            hasFloatingPlaceholder: false,
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
      ),
    );
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  void toggleObscure() {
    setState(() {
      obsecurePassword = !obsecurePassword;
    });
  }

  void loginService() async {
    setState(() {
      _isLoading = true;
    });
    LoginProvider service = new LoginProvider();
    await service.encryptPassword(_passCtrl.text).then((response) async {
      var value = encryptModelFromJson(response.body);

      print(value.response);
      await loginBloc.login(context, _contactAnggota, value.response);
    });
    print('Done');
    setState(() {
      _isLoading = false;
    });
  }

  void getUserDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _idAnggota = _pref.getString(NOMOR_ANGGOTA);
    _imgProfile = _pref.getString(IMG_PROFILE);
    _contactAnggota = _pref.getString(CONTACT_ANGGOTA);
    setState(() {});

    print(_imgProfile);
  }

  void navLogout() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
