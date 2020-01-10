import 'package:flutter/material.dart';
import 'package:kopbi/src/views/kredit_screen/pengajaun_kredit.dart';

class KreditScreen extends StatefulWidget {
  @override
  _KreditScreenState createState() => _KreditScreenState();
}

class _KreditScreenState extends State<KreditScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          title: Text(
            'Kredit',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Kredit Berjalan"),
              Tab(text: "Pengajuan Kredit")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text(
                'Tidak ada Kredit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black45,
                ),
              ),
            ),
            Center(
              child: Text(
                'Belum ada pengajuan Kredit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => PengajuanKredit(),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          tooltip: "Pengajuan Kredit",
        ),
      ),
    );
  }
}
