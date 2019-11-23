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
    return Container(
      child: _bannerInformasi
    );
  }
}
