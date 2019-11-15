import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class InfoTabs extends StatefulWidget {
  @override
  _InfoTabsState createState() => _InfoTabsState();
}

class _InfoTabsState extends State<InfoTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
            child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Container(
                height: 150,
                width: screenWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage(
                          'http://solusi.kopbi.or.id:8888/kobi-images/informasi/${index + 1}.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
