import 'package:flutter/material.dart';
import 'package:kopbi/src/services/banner.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class InfoTabs extends StatefulWidget {
  @override
  _InfoTabsState createState() => _InfoTabsState();
}

class _InfoTabsState extends State<InfoTabs> {
  MyBanner _bannerInformasi;

  @override
  void initState() {
    _bannerInformasi = MyBanner(title: 'informasi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(child: _bannerInformasi),
      onWillPop: _onWillPop,
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
