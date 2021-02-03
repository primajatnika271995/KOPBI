import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:url_launcher/url_launcher.dart';

class CovidInfoScreen extends StatefulWidget {
  @override
  _CovidInfoScreenState createState() => _CovidInfoScreenState();
}

class _CovidInfoScreenState extends State<CovidInfoScreen> {
  bool _loading = false;

  var dateFormat = DateFormat("dd MMM yyyy");
  var timeFormat = DateFormat("HH:mm");

  String jumlahTerkonfirmasi = "0";
  String jumlahKasusAktif = "0";
  String jumlahSembuh = "0";
  String jumlahMeninggal = "0";

  List<CovidProvinsi> listCovidProvinsi = [];

  void getDataCovidIndonesia() async {
    Dio _dio = new Dio();
    Response response = await _dio.post(
      "https://api.kawalcorona.com/indonesia/",
    );
    setState(() {
      jumlahTerkonfirmasi = response.data[0]["positif"];
      jumlahMeninggal = response.data[0]["meninggal"];
      jumlahSembuh = response.data[0]["sembuh"];
      jumlahKasusAktif = response.data[0]["dirawat"];
    });
  }

  void getDataCovidProvinsi() async {
    setState(() {
      _loading = true;
    });

    Dio _dio = new Dio();
    Response response = await _dio.post(
      "https://api.kawalcorona.com/indonesia/provinsi/",
    );

    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0; i <= 32; i++) {
          listCovidProvinsi.add(CovidProvinsi(
            namaProvinsi: response.data[i]["attributes"]["Provinsi"],
            totalPositif: response.data[i]["attributes"]["Kasus_Posi"],
          ));
        }
      });

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getDataCovidIndonesia();
    getDataCovidProvinsi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Informasi langsung COVID-19"),
        elevation: 0,
        titleSpacing: 0.0,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              Colors.green[300],
                              Colors.green[400],
                              Colors.green[500],
                              Colors.green[500],
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                            bottom:
                                new Radius.elliptical(screenWidth(context), 40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/covid-19.png",
                                    height: 80,
                                  ),
                                  Image.asset(
                                    "assets/icons/human.png",
                                    height: 100,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Kasus COVID-19 di Indonesia",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 7),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        height: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  bottomLeft:
                                                      Radius.circular(7),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "$jumlahTerkonfirmasi",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Terkonfirmasi",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  bottomLeft:
                                                      Radius.circular(7),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "$jumlahKasusAktif",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 1.0,
                                                          color: Colors.orange),
                                                    ),
                                                    Text(
                                                      "Kasus Aktif",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        height: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.greenAccent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  bottomLeft:
                                                      Radius.circular(7),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "$jumlahSembuh",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 1.0,
                                                          color: Colors
                                                              .greenAccent),
                                                    ),
                                                    Text(
                                                      "Sembuh",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  bottomLeft:
                                                      Radius.circular(7),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "$jumlahMeninggal",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 1.0,
                                                          color: Colors.red),
                                                    ),
                                                    Text(
                                                      "Meninggal",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  "Update Terakhir: ${dateFormat.format(DateTime.now())} ${timeFormat.format(DateTime.now())}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Provinsi",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Kasus Positif",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            _loading
                                ? Center(
                                    child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator()),
                                  )
                                : ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                                "${listCovidProvinsi[index].namaProvinsi}"),
                                            Text(
                                                "${listCovidProvinsi[index].totalPositif} orang"),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: listCovidProvinsi.length,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  width: screenWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Text(
                          "Pusat Layanan COVID-19",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text("119"),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 0, right: 15),
                            leading: Container(
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  )),
                              child: Center(
                                child: Text(
                                  "1",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                launch("tel:119");
                              },
                              child: CircleAvatar(
                                radius: 13,
                                child: Icon(
                                  Icons.call,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text("(021) - 5210 - 411"),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 0, right: 15),
                            leading: Container(
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  )),
                              child: Center(
                                child: Text(
                                  "2",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                launch("tel:0215210411");
                              },
                              child: CircleAvatar(
                                radius: 13,
                                child: Icon(
                                  Icons.call,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CovidProvinsi {
  String namaProvinsi;
  int totalPositif;

  CovidProvinsi({this.namaProvinsi, this.totalPositif});
}
