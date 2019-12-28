import 'package:flutter/material.dart';
import 'package:kopbi/src/views/perumahan_screen/pengajuan_kpr.dart';

class IsiUlangScreen extends StatefulWidget {
  @override
  _IsiUlangScreenState createState() => _IsiUlangScreenState();
}

class _IsiUlangScreenState extends State<IsiUlangScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Item selectedUser;
  List<Item> users = <Item>[
    const Item('25.000'),
    const Item('50.000'),
    const Item('100.000'),
    const Item('500.000'),
    const Item('1.000.000'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          title: Text(
            'Isi Ulang',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[Tab(text: "Pulsa"), Tab(text: "Token Listrik")],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            isiPulsa(),
            isiToken(),
          ],
        ),
      ),
    );
  }

  Widget isiPulsa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nomor Ponsel',
              labelStyle: TextStyle(color: Colors.black),
              suffixIcon: Icon(
                Icons.phone_android,
                color: Colors.black,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Text(
            "Nominal",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton<Item>(
              isExpanded: true,
              hint: Text("Pilih Nominal"),
              value: selectedUser,
              onChanged: (Item Value) {
                setState(() {
                  selectedUser = Value;
                });
              },
              items: users.map((Item user) {
                return DropdownMenuItem<Item>(
                  value: user,
                  child: Text(
                    user.name,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.cyan,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text("Proses", style: TextStyle(fontSize: 16.0)),
              ),
              onPressed: () {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Maaf transaksi anda belum dapat diproses'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget isiToken() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nomor Meter',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Text(
            "Nominal",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton<Item>(
              isExpanded: true,
              hint: Text("Pilih Nominal"),
              value: selectedUser,
              onChanged: (Item Value) {
                setState(() {
                  selectedUser = Value;
                });
              },
              items: users.map((Item user) {
                return DropdownMenuItem<Item>(
                  value: user,
                  child: Text(
                    user.name,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.cyan,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text("Proses", style: TextStyle(fontSize: 16.0)),
              ),
              onPressed: () {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Maaf transaksi anda belum dapat diproses'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
