import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class PusatBantuanScreen extends StatefulWidget {
  @override
  _PusatBantuanScreenState createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _WACtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Hubungi Kami',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        children: <Widget>[
          info1(),
          SizedBox(height: 10),
          info2(),
        ],
      ),
    );
  }

  Widget info1() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: Text(
                'Punya pertanyaan? Hubungan tim kami untuk respons cepat.',
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 20, top: 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.check, color: Colors.lightGreen),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Senin s.d Jumat',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.check, color: Colors.lightGreen),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '08.00 s.d 17.00',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: screenWidth(context),
                child: RaisedButton(
                  onPressed: () {
                    FlutterOpenWhatsapp.sendSingleMessage("+6285920034045", "");
                  },
                  color: Colors.blueAccent,
                  child: Text(
                    'Tanya Tim Kami',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget info2() {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          'Opsi Lainnya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              readOnly: true,
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
              maxLines: null,
              controller: _emailCtrl,
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: Icon(Icons.mail_outline, color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 7, right: 130),
            child: Text(
              '● Respons melalui email pribadi Anda.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            height: 2,
            width: screenWidth(context),
            color: Colors.grey[400],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              readOnly: true,
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
              maxLines: null,
              controller: _phoneCtrl,
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                labelText: 'Nomor Telepon',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: Icon(Icons.phone, color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 7, right: 175),
            child: Text(
              '● Dikenakan tarif penggunaan.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            height: 2,
            width: screenWidth(context),
            color: Colors.grey[400],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              readOnly: true,
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
              maxLines: null,
              controller: _WACtrl,
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                labelText: 'Nomor WhatsApp',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: Icon(Icons.phone_android, color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 7, right: 180),
            child: Text(
              '● Dikenakan tarif data seluler.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            height: 2,
            width: screenWidth(context),
            color: Colors.grey[400],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              readOnly: true,
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
              maxLines: null,
              controller: _alamatCtrl,
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                labelText: 'Kantor Sekertariat KOPBI Indonesia',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: Icon(Icons.streetview, color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _alamatCtrl.text =
        'Jl. Wika No. 52 Srengsengsawah Jagakarsa - Jakarta Selatan';
    _emailCtrl.text = 'info@kopbi.or.id';
    _phoneCtrl.text = '021 - 29120 134';
    _WACtrl.text = '0859 2003 4045';
    super.initState();
  }
}
