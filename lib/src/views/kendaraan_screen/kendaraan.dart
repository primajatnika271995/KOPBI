import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/isiulang_screen/list_pengajuan_penarikan.dart';
import 'package:kopbi/src/views/kendaraan_screen/add_pengjuan_kredit_kendaraan.dart';
import 'package:kopbi/src/views/kendaraan_screen/list_kendaraan_berjalan.dart';
import 'package:kopbi/src/views/kendaraan_screen/pengajuan_kendaraan.dart';
import 'package:kopbi/src/views/perumahan_screen/pengajuan_kpr.dart';

class KendaraanScreen extends StatefulWidget {
  @override
  _KendaraanScreenState createState() => _KendaraanScreenState();
}

class _KendaraanScreenState extends State<KendaraanScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          title: Text(
            'Kendaraan',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Kredit Berjalan"),
              Tab(text: "Pengajuan Kendaraan")
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                ListKendaraanBerjalanView(),
                AddPengajuanKreditKendaraan()
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => PengajuanKendaraan(),
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
