import 'package:flutter/material.dart';

class DetailsInfoScreen extends StatefulWidget {
  final String url;
  final String keterangan;
  DetailsInfoScreen({this.url, this.keterangan});

  @override
  _DetailsInfoScreenState createState() => _DetailsInfoScreenState();
}

class _DetailsInfoScreenState extends State<DetailsInfoScreen> {
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 325.0,
                  height: 185.0,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                      image: NetworkImage(widget.url),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
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
