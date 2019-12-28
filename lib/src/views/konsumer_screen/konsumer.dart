import 'package:flutter/material.dart';

class KonsumerScreen extends StatefulWidget {
  @override
  _KonsumerScreenState createState() => _KonsumerScreenState();
}

class _KonsumerScreenState extends State<KonsumerScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          title: Text(
            'Konsumer',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Riwayat Konsumer"),
              Tab(text: "Pengajuan Konsumer")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text(
                'Tidak ada riwayat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black45,
                ),
              ),
            ),
            Center(
              child: Text(
                'Tidak ada pengajuan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
