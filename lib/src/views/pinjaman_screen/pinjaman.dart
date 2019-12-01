import 'package:flutter/material.dart';
import 'package:kopbi/src/views/pinjaman_screen/list_pengajuan.dart';
import 'package:kopbi/src/views/pinjaman_screen/list_pinjaman.dart';

class PinjamanScreen extends StatefulWidget {
  @override
  _PinjamanScreenState createState() => _PinjamanScreenState();
}

class _PinjamanScreenState extends State<PinjamanScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Pinjaman"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "List Pinjaman"),
              Tab(text: "List Pengajuan"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PengajuanListPage(),
            PinjamanListPage(),
          ],
        ),
      ),
    );
  }
}
