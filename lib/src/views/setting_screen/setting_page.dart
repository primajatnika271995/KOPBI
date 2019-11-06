import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'SETTINGS',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              settingAkunField(),
              versionApp(),
              logoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingAkunField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Akun',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Ubah Foto Profile',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('UBAH FOTO PROFILE');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Ubah Password',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Ubah Password');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Tentang KOPBI Indonesia',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Tentang KOPBI');
              Navigator.of(context).pushNamed('/settings-informasi');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Pusat Bantuan',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Pusat Bantuan');
              Navigator.of(context).pushNamed('/settings-pusat-bantuan');
            },
          ),
        ),
      ],
    );
  }

  Widget keamananField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            'Keamanan',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Ubah Security Code',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Security Code');
            },
          ),
        ),
      ],
    );
  }

  Widget tentangField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            'Tentang',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Tentang KOPBI',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Tentang Kopbi');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Kebijakan Provasi',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Kebijakan Provasi');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: 'Pusat Bantuan',
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () {
              print('Pusat Bantuan');
            },
          ),
        ),
      ],
    );
  }

  Widget versionApp() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        'Version 1.0.0',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget logoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        width: screenWidth(context),
        child: OutlineButton(
          onPressed: navLogout,
          child: Text(
            'SIGN OUT',
            style: TextStyle(color: Colors.cyan),
          ),
          borderSide: BorderSide(color: Colors.cyan),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  void navLogout() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
