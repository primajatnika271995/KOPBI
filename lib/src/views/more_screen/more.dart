import 'package:flutter/material.dart';
import 'package:kopbi/src/services/laporan.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  List<String> _alpahbet = ['a'];

  MyLaporan _laporanInformasi;

  @override
  void initState() {
    _laporanInformasi = MyLaporan(title: 'laporan');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Laporan',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Container(
          child: _laporanInformasi
      ),
    );
  }
}
