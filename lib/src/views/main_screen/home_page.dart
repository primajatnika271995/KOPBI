import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          balanceField(),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                menuRow1(),
                menuRow2(),
//              iklanField(),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.green,
        height: 100,
        child: bottomMenu(),
      ),
    );
  }

  Widget balanceField() {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.green,
          height: 130,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        'Saldo Simpanan',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(text: 'Rp', style: TextStyle(fontSize: 13)),
                          TextSpan(
                              text: ' 134 ',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20)),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: 'SHU KOPBI',
                              style: TextStyle(fontSize: 13)),
                          TextSpan(
                              text: ' 2.040 ',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13)),
                        ]),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        'Saldo Pinjaman',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(text: 'Rp', style: TextStyle(fontSize: 13)),
                          TextSpan(
                              text: ' 120.000 ',
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 20)),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 90, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/profile-icon.png'),
                  backgroundColor: Colors.green,
                  radius: 30,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'GAYUH PRIANJI',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '000-000-001',
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget menuRow1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Simpanan.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Simpanan',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Pinjaman.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Pinjaman',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Konsumer.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Konsumer',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Perumahan.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Perumahan',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget menuRow2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Isi Ulang.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Isi ulang',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Tiket.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Tiket',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Kredit.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Kredit',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      1000),
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/Selengkapnya-01.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'More',
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
              icon: Icon(FontAwesomeIcons.globe),
              color: Colors.lightGreen,
              onPressed: () {},
              iconSize: 35),
          radius: 30,
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
              icon: Icon(FontAwesomeIcons.instagram),
              color: Colors.redAccent,
              onPressed: () {},
              iconSize: 35),
          radius: 30,
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
              icon: Icon(FontAwesomeIcons.twitter),
              color: Colors.blue,
              onPressed: () {},
              iconSize: 35),
          radius: 30,
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
              icon: Icon(FontAwesomeIcons.youtube),
              color: Colors.red,
              onPressed: () {},
              iconSize: 35),
          radius: 30,
        ),
      ],
    );
  }

  Widget iklanField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 150,
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  height: 150,
                  width: 270,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      image: DecorationImage(
                        image: NetworkImage(
                            'http://pinjamanringan.com/wp-content/uploads/2017/03/Pinjaman-Tunai-Cepat-Mudah-Bunga-Super-Ringan-Segera-Cair-di-Benowo-Surabaya.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  height: 150,
                  width: 270,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://i1.wp.com/www.tercanggih.com/wp-content/uploads/2019/04/Koperasi-Simpan-Pinjam-Pracico.jpg?fit=581%2C349'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
