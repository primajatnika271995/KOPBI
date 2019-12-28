import 'package:flutter/material.dart';
import 'package:kopbi/src/views/perumahan_screen/pengajuan_kpr.dart';

class PerumahanScreen extends StatefulWidget {
  @override
  _PerumahanScreenState createState() => _PerumahanScreenState();
}

class _PerumahanScreenState extends State<PerumahanScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          title: Text(
            'Perumahan',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "KPR Berjalan"),
              Tab(text: "Pengajuan KPR")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text(
                'Tidak ada KPR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black45,
                ),
              ),
            ),
            Center(
              child: Text(
                'Belum ada pengajuan KPR',
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
                builder: (context) => PengajuanKPR(),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          tooltip: "Pengajuan KPR",
        ),
      ),
    );
  }
}
