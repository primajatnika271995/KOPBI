import 'package:flutter/material.dart';

class KreditScreen extends StatefulWidget {
  @override
  _KreditScreenState createState() => _KreditScreenState();
}

class _KreditScreenState extends State<KreditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Kredit',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/icons/no_data.png', height: 250, width: 250),
            Text(
              'Maaf, menu belum bisa anda gunakan untuk saat ini.',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
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
