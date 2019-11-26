import 'package:flutter/material.dart';
import 'package:kopbi/src/services/banner.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class EventTabs extends StatefulWidget {
  @override
  _EventTabsState createState() => _EventTabsState();
}

class _EventTabsState extends State<EventTabs> {
  List<String> _alpahbet = ['a'];

  MyBanner _bannerEvent;
  MyBanner _bannerInformasi;

  @override
  void initState() {
    _bannerInformasi = MyBanner(title: 'informasi');
    _bannerEvent = MyBanner(title: 'event');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        child: _bannerEvent
      ),
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
