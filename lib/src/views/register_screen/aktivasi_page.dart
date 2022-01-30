import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kopbi/src/services/userApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' show join;

class AktivasiScreen extends StatefulWidget {
  @override
  _AktivasiScreenState createState() => _AktivasiScreenState();
}

class _AktivasiScreenState extends State<AktivasiScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey;

  bool isPrivacy = false;

  //CameraDescription camera;
  //CameraController _controller;
  Future<void> _initializeControllerFuture;

  User _user;

  TabController _tabController;
  int _tabIndex;

  FocusNode _userIDFocus;
  FocusNode _ktpFocus;
  FocusNode _hpFocus;
  FocusNode _passwordBaruFocus;
  FocusNode _passwordKonfirmasiFocus;

  TextEditingController userIDController;
  TextEditingController ktpController;
  TextEditingController hpController;
  TextEditingController passwordBaruController;
  TextEditingController passwordKonfirmasiController;
  String _userID;
  String _ktp;
  String _hp;

  String _passwordSementara;
  String _passwordBaru;
  String _passwordKonfirmasi;

  String _fotoPath;

  bool isLoading;

  double logoSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scaffoldKey = new GlobalKey<ScaffoldState>();

    _user = new User();

    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);

    isLoading = false;

    _fotoPath = '';

    _userIDFocus = FocusNode();
    _ktpFocus = FocusNode();
    _hpFocus = FocusNode();
    _passwordBaruFocus = FocusNode();
    _passwordKonfirmasiFocus = FocusNode();

    _userIDFocus.addListener(_focus1Listener);
    _ktpFocus.addListener(_focus2Listener);
    _hpFocus.addListener(_focus3Listener);

    _userID = '';
    userIDController = new TextEditingController();
    userIDController.addListener(() {
      setState(() {
        _userID = userIDController.text;
      });
    });

    _ktp = '';
    ktpController = new TextEditingController();
    ktpController.addListener(() {
      setState(() {
        _ktp = ktpController.text;
      });
    });

    _hp = '';
    hpController = new TextEditingController();
    hpController.addListener(() {
      setState(() {
        _hp = hpController.text;
      });
    });

    _passwordSementara = '123';

    _passwordBaru = '';
    passwordBaruController = new TextEditingController();
    passwordBaruController.addListener(() {
      setState(() {
        _passwordBaru = passwordBaruController.text;
      });
    });

    _passwordKonfirmasi = '';
    passwordKonfirmasiController = new TextEditingController();
    passwordKonfirmasiController.addListener(() {
      setState(() {
        _passwordKonfirmasi = passwordKonfirmasiController.text;
      });
    });

    logoSize = 100.0;
  }

  /* void initCamera() async {
    final cameras = await availableCameras();
    camera = cameras.first;

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  } */

  void _focus1Listener() {
    if(_userIDFocus.hasFocus || _passwordBaruFocus.hasFocus) resizeLogo(1);
  }

  void _focus2Listener() {
    if(_ktpFocus.hasFocus || _passwordKonfirmasiFocus.hasFocus) resizeLogo(2);
  }

  void _focus3Listener() {
    if(_hpFocus.hasFocus) resizeLogo(3);
    //else resizeLogo(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userIDController.dispose();
    ktpController.dispose();
    hpController.dispose();

    _userIDFocus.removeListener(_focus1Listener);
    _ktpFocus.removeListener(_focus2Listener);
    _hpFocus.removeListener(_focus3Listener);

    /* if(_controller != null) {
      _controller.dispose();
    } */

    super.dispose();
  }

  void login({BuildContext context, String userID, String password}) async {
    setState(() {
      isLoading = true;
    });

    Future<LoginStatus> loginStatus = _user.login(userID: userID, password: password);

    loginStatus.then((status) {
      setState(() {
        isLoading = false;
      });

      print("status $status");

      switch (status) {
        case LoginStatus.success:
          if(_ktp == _user.nomorKtp && _hp == _user.nomorHp) {
            String namaUser = _user.nama;
            String nomorKTP = _user.nomorKtp;
            String nomorHP = _user.nomorHp;

            const adminEmail = "cs@kopbi.or.id";
            const subject = "Permohonan%20Aktivasi%20Anggota";
            String body = "Permohonan%20Aktivasi%20Anggota%0A%0AUser%20ID%20%3A%20$userID%0ANama%20User%20%3A%20$namaUser%0ANomor%20KTP%20%3A%20$nomorKTP%0ANomor%20HP%20%3A%20$nomorHP%0A%0AMohon%20dapat%20diaktivasikan%20account%20tersebut%20di%20atas.%20Terima%20kasih";
            String url = "mailto:$adminEmail?subject=$subject&body=$body";

            canLaunch(url).then((isCanLaunch) {
              if(isCanLaunch) {
                launch(url).then((_) {
                  Navigator.pop(context);
                });
              }
            });
            //changeTabIndex(1);
            //initCamera();
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Identitas tidak sesuai"),
            ));
          }
          break;
        case LoginStatus.userNotFound:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("User ID tidak ditemukan"),
          ));
          break;
        case LoginStatus.serverError:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Terjadi kesalahan pada server. (500)"),
          ));
          break;
        case LoginStatus.noInternet:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Periksa koneksi internet anda"),
          ));
          break;
        case LoginStatus.failed:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Terjadi kesalahan. (0x1)"),
          ));
          break;
      }
    });
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();

    FocusScope.of(context).requestFocus(nextFocus);
  }

  void resizeLogo(int level) {
    setState(() {
      logoSize = 100.0 / level;
    });
  }

  void _fotoCaptured(String path) {
    setState(() {
      _fotoPath = path;
    });
  }

  void changeTabIndex(int to) {
    setState(() {
      _tabIndex = to;
    });

    _tabController.animateTo(to);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Aktivasi Anggota KOPBI',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height: 500.0,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: <Widget>[
                      informasiRegister(),
                      TextFormField(
                        controller: userIDController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        focusNode: _userIDFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          _fieldFocusChange(context, _userIDFocus, _ktpFocus);
                        },
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          labelText: 'Nama Lengkap',
                          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: ktpController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        focusNode: _ktpFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          _fieldFocusChange(context, _ktpFocus, _hpFocus);
                        },
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          labelText: 'Nomor KTP',
                          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: hpController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        focusNode: _hpFocus,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (v) {
                          if(!isLoading) {
                            if(_userID.isNotEmpty && _passwordSementara.isNotEmpty && _ktp.isNotEmpty && _hp.isNotEmpty) {
                              //login(context: context, userID: _userID, password: _ktp);
                              login(context: context, userID: _userID, password: _passwordSementara);
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Isi data pribadi"),
                              ));
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          labelText: 'Nomor Ponsel',
                          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      acceptPrivacyPoliceField(),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: isLoading ?
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(backgroundColor: Colors.white),
                                  ) :
                                  Text("Aktivasi", style: TextStyle(fontSize: 17.0)),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if(!isLoading) {
                                    if(_userID.isNotEmpty && _passwordSementara.isNotEmpty && _ktp.isNotEmpty && _hp.isNotEmpty) {
                                      //login(context: context, userID: _userID, password: _ktp);
                                      login(context: context, userID: _userID, password: _passwordSementara);
                                    } else {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Isi data pribadi"),
                                      ));
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width - 40.0,
                  child: Column(
                    children: <Widget>[
                      Text("Unggah foto KTP Anda", style: TextStyle(color: Colors.black, fontSize: 18.0)),

                      SizedBox(height: 20.0),
                      RaisedButton(
                        padding: EdgeInsets.all(5.0),
                        color: Colors.white,
                        disabledColor: Colors.white,
                        hoverElevation: 5.0,
                        child: Container(
                          height: (MediaQuery.of(context).size.width - 40.0) / 2,
                          width: MediaQuery.of(context).size.width - 60.0,
                          //child: _fotoPath.isNotEmpty ? Image.file(File(_fotoPath)) : Icon(Icons.camera_alt, size: 50.0),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: -220.0,
                                left: -40.0,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: _fotoPath.isNotEmpty ? Image.file(File(_fotoPath)) : Container(
                                  child: FutureBuilder<void>(
                                    future: _initializeControllerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        // If the Future is complete, display the preview.
                                        return null;
                                        //return CameraPreview(_controller);
                                      } else {
                                        // Otherwise, display a loading indicator.
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onPressed: _fotoPath.isNotEmpty ? () {
                          setState(() {
                            _fotoPath = '';
                          });
                        } : null,
                      ),

                      SizedBox(height: 20.0),
                      Text(_fotoPath.isEmpty ? "Pastikan KTP ada di dalam kotak" : "Klik gambar untuk mengulang", style: TextStyle(color: Colors.black, fontSize: 14.0)),
                      SizedBox(height: 20.0),

                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 10.0),
                                child: FlatButton(
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: isLoading ?
                                    Container(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(backgroundColor: Colors.white),
                                    ) :
                                    Text("Sebelumnya", style: TextStyle(fontSize: 17.0)),
                                  ),
                                  onPressed: () {
                                    changeTabIndex(0);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: FlatButton(
                                  color: Colors.blue,
                                  disabledColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: isLoading ?
                                    Container(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(backgroundColor: Colors.white),
                                    ) :
                                    Text("Aktivasi", style: TextStyle(fontSize: 17.0)),
                                  ),
                                  onPressed: _fotoPath.isNotEmpty ? () {
                                    if(!isLoading) {
                                      changeTabIndex(2);
                                    }
                                  } : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width - 40.0,
                  child: Column(
                    children: <Widget>[
                      Text("Ubah password", style: TextStyle(color: Colors.black, fontSize: 18.0)),

                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(color: Color.fromARGB(130, 0, 0, 0), offset: Offset.fromDirection(20.0), blurRadius: 5.0, spreadRadius: -1.0)
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordBaruController,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: true,
                          focusNode: _passwordBaruFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            _fieldFocusChange(context, _passwordBaruFocus, _passwordKonfirmasiFocus);
                          },
                          decoration: InputDecoration(
                            hintText: 'Password Baru (min. 4 karakter)',
                            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(color: Color.fromARGB(130, 0, 0, 0), offset: Offset.fromDirection(20.0), blurRadius: 5.0, spreadRadius: -1.0)
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordKonfirmasiController,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: true,
                          focusNode: _passwordKonfirmasiFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if(!isLoading) {
                              if(_passwordBaru.isNotEmpty && _passwordKonfirmasi.isNotEmpty) {
                                if(_passwordBaru.length <= 3) {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("Password minimal 4 karakter"),
                                  ));
                                } else {
                                  if(_passwordBaru != _passwordKonfirmasi) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Harap konfirmasi password baru dengan benar"),
                                    ));
                                  }
                                }
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Harap lengkapi semua kolom"),
                                ));
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi Password Baru',
                            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: isLoading ?
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(backgroundColor: Colors.white),
                                  ) :
                                  Text("Simpan", style: TextStyle(fontSize: 17.0)),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if(!isLoading) {
                                    if(_passwordBaru.isNotEmpty && _passwordKonfirmasi.isNotEmpty) {
                                      if(_passwordBaru != _passwordKonfirmasi) {
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Text("Harap konfirmasi password baru dengan benar"),
                                        ));
                                      } else {
                                        const userID = "";
                                        const namaUser = "";
                                        const nomorKTP = "";
                                        const nomorHP = "";

                                        const adminEmail = "cs@kopbi.or.id";
                                        const subject = "Permohonan%20Aktivasi%20Anggota";
                                        const body = "Permohonan%20Aktivasi%20Anggota%0A%0AUser%20ID%20%3A%20$userID%0ANama%20User%20%3A%20$namaUser%0ANomor%20KTP%20%3A%20$nomorKTP%0ANomor%20HP%20%3A%20$nomorHP%0A%0AMohon%20dapat%20diaktivasikan%20account%20tersebut%20di%20atas.%20Terima%20kasih";
                                        const url = "mailto:$adminEmail?subject=$subject&body=$body";

                                        canLaunch(url).then((isCanLaunch) {
                                          if(isCanLaunch) {
                                            launch(url).then((_) {
                                              Navigator.pop(context);
                                            });
                                          }
                                        });

                                        //Navigator.pushReplacement(context, SlideTopRoute(page: HomePage(user: _user)));
                                        /* showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                  title: Text('Terima Kasih'),
                                                  content: Text('Aktivasi Anda segera kami proses, pastikan nomor HP terdaftar selalu aktif untuk konfirmasi selanjutnya'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Selesai'),
                                                    ),
                                                  ],
                                                )
                                              ).then((_) {
                                                Navigator.pop(context);
                                              }); */
                                      }
                                    } else {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Harap lengkapi semua kolom"),
                                      ));
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: _tabIndex == 1 && _fotoPath.isEmpty ? FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            _fotoCaptured(path);
          } catch (e) {
            print(e);
          }
        },
      ) : null,
    );
  }

  Widget informasiRegister() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      child: Text(
        'Terima kasih telah bergabung sebagai anggota KOPBI Indonesia. Lengkapi data pribadi anda dibawah ini. Kami akan mengirimkan verifikasi data anda melalui SMS / WA / Email yang anda cantumkan dibawah ini.',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget acceptPrivacyPoliceField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isPrivacy,
            onChanged: (bool value) {
              setState(() {
                isPrivacy = value;
              });
            },
            activeColor: Colors.green,
          ),
          Container(
            width: 300,
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'Saya setuju dengan',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: ' Syarat & Ketentuan ',
                  style: TextStyle(color: Colors.cyan, fontSize: 13),
                ),
                TextSpan(
                  text: 'dan',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: ' Kebijakan Privasi ',
                  style: TextStyle(color: Colors.cyan, fontSize: 13),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget berikutnyaButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: screenWidth(context),
        child: RaisedButton(
          onPressed: () {},
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
