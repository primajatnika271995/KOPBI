import 'package:flutter/material.dart';

class DetailsInfoIklanScreen extends StatefulWidget {
  final String url;
  final String keterangan;
  DetailsInfoIklanScreen({this.url, this.keterangan});

  @override
  _DetailsInfoIklanScreenState createState() => _DetailsInfoIklanScreenState();
}

class _DetailsInfoIklanScreenState extends State<DetailsInfoIklanScreen> {
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
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Card(
                child: Image.network(widget.url),
              ),
            ),
            Divider(),
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
