import 'package:flutter/material.dart';

class TiketScreen extends StatefulWidget {
  @override
  _TiketScreenState createState() => _TiketScreenState();
}

class _TiketScreenState extends State<TiketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Tiket',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/icons/no_data.png', height: 250, width: 250),
//            Text(
//              'Tidak Ada Riwayat',
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//            ),
//            Padding(
//              padding: EdgeInsets.symmetric(horizontal: 40),
//              child: Text(
//                'Perbanyak transaksimu dan nikmati berbagai promo menarik dari KOPBI Solution.',
//                style: TextStyle(fontSize: 13),
//                textAlign: TextAlign.center,
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
