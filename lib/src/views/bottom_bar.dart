import 'package:flutter/material.dart';
import 'package:kopbi/src/views/chat_screen/details_chat.dart';
import 'package:kopbi/src/views/main_screen/kartu_anggota.dart';
import 'package:kopbi/src/views/main_screen/new_home_page.dart';
import 'package:kopbi/src/views/main_screen/profile.dart';
import 'package:kopbi/src/views/setting_screen/pusat_bantuan.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    NewHomePage(),
    DetailsChatView(),
    KartuAnggota(),
    PusatBantuanScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            title: Text('Member'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_help),
            title: Text('Bantuan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profil'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
