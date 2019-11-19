import 'package:flutter/material.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KartuAnggota extends StatefulWidget {
  @override
  _KartuAnggotaState createState() => _KartuAnggotaState();
}

class _KartuAnggotaState extends State<KartuAnggota> {
  String nama = 'admin';
  String idNumber = 'admin';
  String tglRegister = 'admin';

  @override
  void initState() {
    // TODO: implement initState
    getDetails();
    super.initState();
  }

  void getDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    nama = _pref.getString(NAMA_ANGGOTA);
    idNumber = _pref.getString(NOMOR_ANGGOTA);
    tglRegister = _pref.getString(TGL_REGISTRASI);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Container(
              width: 300.0,
              height: 155.0,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 15)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7.0)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    width: 350.0,
                    top: -62.0,
                    right: -210.0,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Image(
                          image: AssetImage('assets/icons/Logo KOPBI.png')),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                          height: 50.0,
                          child: Row(
                            children: <Widget>[
                              Container(
                                child:
                                    Image.asset('assets/icons/Logo KOPBI.png'),
                              ),
//                              Expanded(
//                                child: Container(
//                                  child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Text("KARTU ANGGOTA",
//                                          style: TextStyle(fontSize: 18.0)),
//                                      Text("Bersama, Maju, Sejahtera",
//                                          style: TextStyle(
//                                              color: Color.fromARGB(
//                                                  255, 14, 65, 38),
//                                              fontSize: 15.0,
//                                              fontStyle: FontStyle.italic)),
//                                    ],
//                                  ),
//                                ),
//                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('$nama',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              Text('$idNumber'),
                            ],
                          ),
                        ),
//                        SizedBox(height: 30.0),
//                        Text("Terdaftar sejak $tglRegister",
//                            style: TextStyle(fontSize: 13.0))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Text(
          'Sentuh pada kartu untuk melihat detail',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
