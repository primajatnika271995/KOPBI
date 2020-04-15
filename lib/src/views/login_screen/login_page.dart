import 'package:flutter/material.dart';
import 'package:kopbi/src/bloc/loginBloc.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/models/encrypt_model.dart';
import 'package:kopbi/src/services/loginApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//  Varible boolean
  bool obsecurePassword = true;
  bool _isLoading = false;

//  Text Controller
  final _userCtrl = new TextEditingController();
  final _passCtrl = new TextEditingController();

//  FormKey
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//                stops: [0.1, 0.5, 0.7, 0.9],
//                colors: [
//                  Colors.green[200],
//                  Colors.green[300],
//                  Colors.green[500],
//                  Colors.green[600],
//                ],
//              ),
              image: DecorationImage(
                  image: AssetImage('assets/logo/leaf-background.jpg'),
                  fit: BoxFit.cover),
            ),
            height: screenHeight(context),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                appLogo(),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      usernameField(),
                      SizedBox(height: 15),
                      passwordField(),
                      signInButton(),
                      registerButton(),
                      bantuanButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget appLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: screenHeight(context, dividedBy: 2.1),
        child:
            Image.asset('assets/icons/Logo-KOPBI.png', height: 150, width: 150),
      ),
    );
  }

  Widget usernameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(130, 0, 0, 0),
                offset: Offset.fromDirection(20.0),
                blurRadius: 5.0,
                spreadRadius: -1.0)
          ],
        ),
        child: TextFormField(
          controller: _userCtrl,
          style: TextStyle(color: Colors.black),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.black),
            hasFloatingPlaceholder: true,
            labelText: 'Nomor Handphone',
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'User ID tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(130, 0, 0, 0),
                offset: Offset.fromDirection(20.0),
                blurRadius: 5.0,
                spreadRadius: -1.0)
          ],
        ),
        child: TextFormField(
          controller: _passCtrl,
          style: TextStyle(color: Colors.black),
          obscureText: obsecurePassword,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.black),
            suffixIcon: InkWell(
              onTap: toggleObscure,
              child: Icon(
                  obsecurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black),
            ),
            hasFloatingPlaceholder: true,
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 5),
      child: Container(
        width: screenWidth(context),
        child: RaisedButton(
          onPressed: _isLoading ? null : loginService,
          child: Text(
            _isLoading ? 'Loading ...' : 'LOGIN',
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

  Widget registerButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: RaisedButton(
                onPressed: navRegister,
                child: Text(
                  'AKTIVASI',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              child: RaisedButton(
                onPressed: navDaftar,
                child: Text(
                  'DAFTAR',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bantuanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: OutlineButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/bantuan');
        },
        icon: Icon(Icons.info, color: Colors.black),
        label: Text(
          'Butuh Bantuan?',
          style: TextStyle(color: Colors.black),
        ),
        borderSide: BorderSide.none,
      ),
    );
  }

  void navRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  void navDaftar() {
    Navigator.of(context).pushNamed('/daftar');
  }

  void navHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void toggleObscure() {
    setState(() {
      obsecurePassword = !obsecurePassword;
    });
  }

  void loginService() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      LoginProvider service = new LoginProvider();
      await service.encryptPassword(_passCtrl.text).then((response) async {
        var value = encryptModelFromJson(response.body);

        print(value.response);
        await loginBloc.login(context, _userCtrl.text, value.response);
      });
      var pref = await SharedPreferences.getInstance();
      pref.setString(DECRYPT_PASSWORD, _passCtrl.text);

      print('Done');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
