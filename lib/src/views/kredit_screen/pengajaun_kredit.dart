import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class PengajuanKredit extends StatefulWidget {
  @override
  _PengajuanKreditState createState() => _PengajuanKreditState();
}

class _PengajuanKreditState extends State<PengajuanKredit> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  double _dLamaAngsuran = 1;
  int _lamaAngsuran = 1;

  Item selectedUser;
  List<Item> users = <Item>[
    const Item(''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ajukan Kredit"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
              ),
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Pilih Kendaraan",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<Item>(
                        isExpanded: true,
                        value: selectedUser,
                        onChanged: (Item Value) {
                          setState(() {
                            selectedUser = Value;
                          });
                        },
                        items: users.map((Item user) {
                          return  DropdownMenuItem<Item>(
                            value: user,
                            child: Text(
                              user.name,
                              style:  TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Spesifikasi",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
                    child: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Berapa lama tenor yang diinginkan?",
                            style: TextStyle(fontSize: 18.0)),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Slider(
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey,
                                value: _dLamaAngsuran,
                                min: 1.0,
                                max: 12.0,
                                divisions: 12,
                                onChanged: (v) {
                                  setState(() {
                                    _dLamaAngsuran = v;
                                    _lamaAngsuran = v.round();
                                  });
                                },
                              ),
                              Center(
                                child: Text(_lamaAngsuran.toString() + ' Bulan',
                                    style: TextStyle(fontSize: 24.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(color: Colors.lightGreen),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Jatuh tempo",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Text("Pokok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Text("Bagi Hasil",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Text("Administrasi",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              SizedBox(height: 10.0),
                              Text("Total tagihan",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(":",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Tanggal 15 bulan selanjutnya",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text("0",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text("0",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text("0",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 35.0,
                                        child: Text('Rp.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        width: 115.0,
                                        child: Text("0",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.green,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child:
                  Text("Buat Pengajuan", style: TextStyle(fontSize: 16.0)),
                ),
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  const Item(this.name);
  final String name;
}
