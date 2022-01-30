import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/isiulang_screen/list_pengajuan_penarikan.dart';
import 'package:kopbi/src/views/perumahan_screen/add_pengajuan_perumahan.dart';
import 'package:kopbi/src/views/perumahan_screen/list_perumahan_berjalan.dart';
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
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                ListPerumahanBerjalanView(),
                AddPengajuanPerumahanView()
              ],
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

