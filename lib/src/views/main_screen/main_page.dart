import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kopbi/src/views/chat_screen/chat_page_view.dart';
import 'package:kopbi/src/views/chat_screen/details_chat.dart';
import 'package:kopbi/src/views/main_screen/event.dart';
import 'package:kopbi/src/views/main_screen/home_page.dart';
import 'package:kopbi/src/views/main_screen/info.dart';
import 'package:kopbi/src/views/main_screen/kartu_anggota.dart';
import 'package:kopbi/src/views/main_screen/profile.dart';

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
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsChatView()
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 12),
            isScrollable: false,
            indicatorColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                text: 'Home',
                icon: Icon(FontAwesomeIcons.home),
              ),
              Tab(
                text: 'Info',
                icon: Icon(FontAwesomeIcons.info),
              ),
              Tab(
                text: 'Event',
                icon: Icon(FontAwesomeIcons.stickyNote),
              ),
              Tab(
                text: 'Card',
                icon: Icon(FontAwesomeIcons.idCard),
              ),
              Tab(
                text: 'Profile',
                icon: Icon(FontAwesomeIcons.pen),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            InfoTabs(),
            EventTabs(),
            KartuAnggota(),
            ProfilePage(),
          ],
//          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  void navSetting() {
    Navigator.of(context).pushNamed('/settings');
  }
}
