import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class EventTabs extends StatefulWidget {
  @override
  _EventTabsState createState() => _EventTabsState();
}

class _EventTabsState extends State<EventTabs> {
  List<String> _alpahbet = ['a', 'b'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _alpahbet.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              child: Container(
                height: 170,
                width: screenWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  image: DecorationImage(
                      image: NetworkImage(
                          'http://solusi.kopbi.or.id:8888/kobi-images/kegiatan/${_alpahbet[index]}.jpg'),
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
