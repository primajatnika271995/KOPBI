import 'package:flutter/material.dart';
import 'package:kopbi/src/services/banner.dart';

class CatatanTabs extends StatefulWidget {
  @override
  _CatatanTabsState createState() => _CatatanTabsState();
}

class _CatatanTabsState extends State<CatatanTabs> {
  MyBanner _bannerEvent;

  @override
  void initState() {
    _bannerEvent = MyBanner(title: 'catatan');
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
        backgroundColor: Colors.green,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Catatan',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: Container(child: _bannerEvent),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Apakah Anda yakin ingin keluar?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Tidak'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yakin'),
          ),
        ],
      ),
    ) ??
        false;
  }
}
