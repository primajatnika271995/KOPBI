import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kopbi/src/views/main_screen/home_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Text(
            'KOPBI Solution',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none),
              color: Colors.grey[300],
              iconSize: 25,
            ),
            IconButton(
              onPressed: navSetting,
              icon: Icon(Icons.settings),
              color: Colors.grey[300],
              iconSize: 25,
            ),
          ],
          bottom: TabBar(
            isScrollable: false,
            labelStyle: TextStyle(fontSize: 13),
            indicatorColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                text: 'Home',
                icon: Icon(FontAwesomeIcons.home),
              ),
              Tab(
                text: 'Promo',
                icon: Icon(FontAwesomeIcons.addressCard),
              ),
              Tab(
                text: 'Event',
                icon: Icon(FontAwesomeIcons.stickyNote),
              ),
              Tab(
                text: 'Member',
                icon: Icon(FontAwesomeIcons.idCard),
              ),
              Tab(
                text: 'Profile',
                icon: Icon(FontAwesomeIcons.pen),
              ),
            ],
          ),
        ),

        body: TabBarView(children: [
          HomeScreen(),
          Center(child: Text('ANOTHER PAGE')),
          Center(child: Text('ANOTHER PAGE')),
          Center(child: Text('ANOTHER PAGE')),
          Center(child: Text('ANOTHER PAGE')),
        ]),
      ),
    );
  }

  void navSetting() {
    Navigator.of(context).pushNamed('/settings');
  }
}
