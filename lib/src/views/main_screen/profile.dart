import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> {
  bool _status = true;

  final imgProfile = TextEditingController();
  final noAnggota = TextEditingController();
  final namaAnggota = TextEditingController();
  final tanggalRegistrasi = TextEditingController();
  final nik = TextEditingController();
  final noContact = TextEditingController();
  final pekerjaan = TextEditingController();
  final tempatLahir = TextEditingController();
  final tanggalLahir = TextEditingController();
  final alamat = TextEditingController();

  final namaPerusahaan = TextEditingController();
  final alamatPerusahaan = TextEditingController();
  final lokasiPenempatan = TextEditingController();
  final namaKonfederasi = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getDetails();
    super.initState();
  }

  void getDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String formatter = _pref.getString(TANGGAL_LAHIR);

    if (formatter != null) {
      String date = formatter.substring(formatter.length - 2);
      String month = formatter.substring(5, 7);
      String year = formatter.substring(0, 4);

      namaAnggota.text = _pref.getString(NAMA_ANGGOTA);
      noAnggota.text = _pref.getString(NOMOR_ANGGOTA);
      tanggalRegistrasi.text = _pref.getString(TGL_REGISTRASI);
      imgProfile.text = _pref.getString(IMG_PROFILE);
      tanggalLahir.text = "$date-$month-$year";
      tempatLahir.text = _pref.getString(TEMPAT_LAHIR);
      alamat.text = _pref.getString(ALAMAT);
      nik.text = _pref.getString(NIK);
      pekerjaan.text = _pref.getString(PEKERJAAN);

      namaPerusahaan.text = _pref.getString(NAMA_PERUSAHAAN);
      alamatPerusahaan.text = _pref.getString(ALAMAT_PERUSAHAAN);
      lokasiPenempatan.text = _pref.getString(LOKASI_PENEMPATAN);
      namaKonfederasi.text = _pref.getString(NAMA_KONFEDERENSI);
    } else {
      namaAnggota.text = _pref.getString(NAMA_ANGGOTA);
      noAnggota.text = _pref.getString(NOMOR_ANGGOTA);
      tanggalRegistrasi.text = _pref.getString(TGL_REGISTRASI);
      imgProfile.text = _pref.getString(IMG_PROFILE);
      tanggalLahir.text = formatter;
      tempatLahir.text = _pref.getString(TEMPAT_LAHIR);
      alamat.text = _pref.getString(ALAMAT);
      nik.text = _pref.getString(NIK);
      pekerjaan.text = _pref.getString(PEKERJAAN);

      namaPerusahaan.text = _pref.getString(NAMA_PERUSAHAAN);
      alamatPerusahaan.text = _pref.getString(ALAMAT_PERUSAHAAN);
      lokasiPenempatan.text = _pref.getString(LOKASI_PENEMPATAN);
      namaKonfederasi.text = _pref.getString(NAMA_KONFEDERENSI);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String formattedTanggalRegistrasi(tglRegsiter) {
      String formatted = tglRegsiter;

      if (tglRegsiter.contains(RegExp(r"^\d{4}\-\d{2}\-\d{2}"))) {
        List<String> split = tglRegsiter.split('-');

        List<String> months = [
          '',
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'Oktober',
          'November',
          'Desember',
        ];

        var bulan = int.parse(split[1]);

        formatted =
            "${split[2].substring(0, split[2].length - 14)}-${split[1]}-${split[0]}";
      }

      return formatted;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profil',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: new Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: new Stack(fit: StackFit.loose, children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  image: imgProfile.text.length < 5
                                      ? AssetImage('assets/icons/no_user.jpg')
                                      : NetworkImage(imgProfile.text),
                                  fit: BoxFit.fitWidth,
                                ),
                              )),
                        ],
                      ),
//                    Padding(
//                        padding: EdgeInsets.only(top: 90.0, right: 100.0),
//                        child: new Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            new CircleAvatar(
//                              backgroundColor: Colors.red,
//                              radius: 25.0,
//                              child: new Icon(
//                                Icons.camera_alt,
//                                color: Colors.white,
//                              ),
//                            )
//                          ],
//                        )),
                    ]),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 45.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Personal Information',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
//                              new Column(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  _status ? _getEditIcon() : new Container(),
//                                ],
//                              )
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Nomor Anggota',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                    hintText: "Nomor Anggota"),
                                controller: noAnggota,
                                enabled: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Nama',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                  hintText: "Enter Your Name",
                                ),
                                controller: namaAnggota,
                                enabled: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'Tempat Lahir',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'Tanggal Lahir',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: new TextField(
                                  decoration:
                                      const InputDecoration(hintText: "Tempat"),
                                  controller: tempatLahir,
                                  enabled: !_status,
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: new TextField(
                                decoration:
                                    const InputDecoration(hintText: "Tanggal"),
                                controller: tanggalLahir,
                                enabled: !_status,
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Pekerjaan',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextField(
                              decoration: const InputDecoration(
                                hintText: "Masukan Pekerjaan",
                              ),
                              controller: pekerjaan,
                              enabled: !_status,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Alamat',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextField(
                              decoration: const InputDecoration(
                                hintText: "Masukan Alamat",
                              ),
                              controller: alamat,
                              maxLines: 2,
                              enabled: !_status,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Company Information',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
//                              new Column(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  _status ? _getEditIcon() : new Container(),
//                                ],
//                              )
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Nomor NIK',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                    hintText: "Nomor NIK"),
                                controller: nik,
                                enabled: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Nama Perusahaan',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                  hintText: "Masukan Nama Perusahaan",
                                ),
                                controller: namaPerusahaan,
                                enabled: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Alamat Perusahaan',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                    hintText: "Masukan Alamat"),
                                controller: alamatPerusahaan,
                                maxLines: null,
                                enabled: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Lokasi Penempatan',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                    hintText: "Masukan Lokasi Penempatan"),
                                controller: lokasiPenempatan,
                                maxLines: null,
                                enabled: !_status,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Confederation Information',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
//                              new Column(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  _status ? _getEditIcon() : new Container(),
//                                ],
//                              )
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Nama Konfederasi',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextField(
                              decoration: const InputDecoration(
                                  hintText: "Masukan Nama Konfederasi"),
                              controller: namaKonfederasi,
                              maxLines: null,
                              enabled: !_status,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah Anda yakin ingin keluar?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Tidak'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yakin'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
