import 'package:flutter/material.dart';

class DetailsInfoCatatanScreen extends StatefulWidget {
  final String keterangan;
  DetailsInfoCatatanScreen({this.keterangan});

  @override
  _DetailsInfoCatatanScreenState createState() => _DetailsInfoCatatanScreenState();
}

class _DetailsInfoCatatanScreenState extends State<DetailsInfoCatatanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Info',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(
                        "http://solusi.kopbi.or.id:8889/kobi-images/informasi/36.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                widget.keterangan == null
                    ? "Tidak ada Keterangan"
                    : widget.keterangan,
                textAlign: TextAlign.justify,
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
