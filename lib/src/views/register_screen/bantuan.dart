import 'package:flutter/material.dart';

class BantuanPage extends StatefulWidget {
  @override
  _BantuanPageState createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            color: Color.fromARGB(255, 253, 253, 253),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                    color: Color.fromARGB(100, 255, 255, 255),
                    colorBlendMode: BlendMode.screen,
                    image: AssetImage('assets/logo/leaf-background.jpg')
                ),
              ],
            ),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Hero(
                  tag: 'hero',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100.0,
                    child: Image.asset('assets/icons/Logo KOPBI.png'),
                  ),
                ),

                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(75, 255, 255, 255),
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Harap menghubungi Admin Kantor Sekretariat", style: TextStyle(color: Colors.black, fontSize: 18.0)),
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.phone),
                              onPressed: () { /* _launchPhone(); */ },
                            ),
                            SizedBox(width: 15.0),
                            Text("(021) 2912 0134")
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.chat),
                              onPressed: () { /* _launchWhatsApp(); */ },
                            ),
                            SizedBox(width: 15.0),
                            Text("0859 2003 4045")
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.email),
                              onPressed: () {/*  _launchEmail(); */ },
                            ),
                            SizedBox(width: 15.0),
                            Text("info@kopbi.or.id")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
