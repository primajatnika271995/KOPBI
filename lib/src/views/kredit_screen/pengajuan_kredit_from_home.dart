import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/services/barangApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/kredit_screen/pengajaun_kredit.dart';

class PengajuanKreditFromHome extends StatefulWidget {
  final Barang data;
  PengajuanKreditFromHome({this.data});

  @override
  _PengajuanKreditFromHomeState createState() =>
      _PengajuanKreditFromHomeState();
}

class _PengajuanKreditFromHomeState extends State<PengajuanKreditFromHome> {
  var hargaBarang = new NumberFormat.currency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("${widget.data.namaBarang}"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: CachedNetworkImage(
                imageUrl:
                "http://solusi.kopbi.or.id:8889/kobi-images/barang/${widget.data.kodeBarang}.jpg",
                placeholder: (context, url) => new CircularProgressIndicator(),
                width: screenWidth(context),
                height: 200,
                fit: BoxFit.contain,
                errorWidget:
                    (context, url, error) =>
                    Image.network(
                      "http://solusi.kopbi.or.id:8889/kobi-images/barang/default.jpg",
                      width: screenWidth(context),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "${hargaBarang.format(widget.data.harga * 10 )}",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.star),
                            onPressed: () {},
                            iconSize: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${widget.data.namaBarang}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: 2,
                        width: screenWidth(context),
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Dijual oleh ",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "KOPBI SOLUTION",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Informasi produk",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Kondisi",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.data.keterangan}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
//                    Padding(
//                      padding:
//                          const EdgeInsets.only(left: 10, right: 10, top: 20),
//                      child: Row(
//                        children: <Widget>[
//                          Text(
//                            "Asuransi",
//                            style: TextStyle(
//                              fontSize: 15,
//                            ),
//                          ),
//                          Spacer(),
//                          Text(
//                            "Ya",
//                            style: TextStyle(
//                              fontSize: 15,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Stok",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.data.stokBarang}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Kategori",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.data.kategori.toUpperCase()}",
                            style: TextStyle(fontSize: 15, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Kode Barang",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.data.kodeBarang}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                width: screenWidth(context),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PengajuanKreditPage(
                        data: widget.data,
                      ),
                    ));
                  },
                  color: Colors.green,
                  child: Text(
                    "Ajukan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
