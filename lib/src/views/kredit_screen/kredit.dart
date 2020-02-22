import 'package:flutter/material.dart';
import 'package:kopbi/src/views/kredit_screen/list_histori_pengajuan_kredit.dart';
import 'package:kopbi/src/views/kredit_screen/list_pengajuan_kredit.dart';
import 'package:kopbi/src/views/kredit_screen/list_pinjaman_kredit.dart';
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
//          actions: <Widget>[
//            IconButton(icon: Icon(Icons.history), onPressed: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => HistoriPengajuanBarangListPage(),
//              ),);
//            }),
//          ],
        ),
        body: TabBarView(
          children: <Widget>[
            PinjamanKreditListPage(),
            PengajuanKreditListPage(),
          ],
        ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            Navigator.of(context)
//                .push(
//              MaterialPageRoute(
//                builder: (context) => PengajuanKreditPage(),
//              ),
//            );
//          },
//          backgroundColor: Colors.green,
//          child: Icon(Icons.add),
//          tooltip: "Pengajuan Kredit",
//        ),
      ),
    );
  }
}
