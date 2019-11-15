import 'package:flutter/material.dart';
import 'package:kopbi/src/bloc/loginBloc.dart';
import 'package:kopbi/src/utils/screenSize.dart';

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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.green[200],
                  Colors.green[300],
                  Colors.green[500],
                  Colors.green[600],
                ],
              ),
//              image: DecorationImage(
//                image: AssetImage('assets/logo/leaf-background.jpg'),
//                fit: BoxFit.cover
//              ),
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
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        height: screenHeight(context, dividedBy: 2.1),
        child:
            Image.asset('assets/icons/Logo KOPBI.png', height: 150, width: 150),
      ),
    );
  }

  Widget usernameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: _userCtrl,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: Colors.white),
          hasFloatingPlaceholder: true,
          labelText: 'User ID',
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
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
          } return null;
        },
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
          hasFloatingPlaceholder: true,
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
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
          } return null;
        },
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
      child: Container(
        width: screenWidth(context),
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
    );
  }

  Widget bantuanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: OutlineButton.icon(
        onPressed: () {},
        icon: Icon(Icons.info, color: Colors.white),
        label: Text(
          'Butuh Bantuan?',
          style: TextStyle(color: Colors.white),
        ),
        borderSide: BorderSide.none,
      ),
    );
  }

  void navRegister() {
    Navigator.of(context).pushNamed('/register');
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
      print('Value userID : ${_userCtrl.text}');
      print('Value Pasword : ${_passCtrl.text}');
      await loginBloc.login(context, _userCtrl.text, _passCtrl.text);
      print('Done');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
