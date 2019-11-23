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
    return Container(
      child: _bannerEvent
    );
  }
}
