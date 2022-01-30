import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/enum/HttpStatus.dart';
import 'package:kopbi/src/services/barangApi.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/kredit_screen/pengajuan_kredit_from_home.dart';

class GridKreditBarang extends StatefulWidget {
  @override
  _GridKreditBarangState createState() => _GridKreditBarangState();
}

class _GridKreditBarangState extends State<GridKreditBarang> {
  ListBarang _dbBarang;
  List<Barang> _listBarang;

  var hargaBarang = new NumberFormat.currency(
      locale: 'id_ID', name: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _listBarang = [];
    _dbBarang = ListBarang();

    _dbBarang.getList().then((_) {
      switch (_) {
        case HttpStatus.success:
          print(_dbBarang.listBarang.length);

          _dbBarang.listBarang.forEach((element) {
            print("STOK");
            print(element.stokBarang);
            print(element.namaBarang);
            print("Harga : ${element.harga}");
          });

          _listBarang = _dbBarang.listBarang
              .where((f) => f.stokBarang >= 1 && f.kategori == 'barang')
              .toList().reversed.toList();

          print("STOCK : $_listBarang");
          print("List Barang Sukses");

          break;
        case HttpStatus.error:
          print("List Barang Error");
          break;
        case HttpStatus.serverError:
          print("List Barang Server Error");
          break;
        case HttpStatus.noInternet:
          print("List Barang No Internet");
          break;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Kredit Barang"),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PengajuanKreditFromHome(
                      data: _listBarang[index],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl:
                        "http://solusi.kopbi.or.id:8889/kobi-images/barang/${_listBarang[index].kodeBarang}.jpg",
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        width: screenWidth(context),
                        height: 150,
                        fit: BoxFit.contain,
                        errorWidget:
                            (context, url, error) =>
                            Image.network(
                              "http://solusi.kopbi.or.id:8889/kobi-images/barang/default.jpg",
                              width: screenWidth(context),
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 15,
                        right: 5,
                        bottom: 3,
                      ),
                      child: Text(
                        "${_listBarang[index].namaBarang}",
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 15,
                        right: 5,
                        bottom: 3,
                      ),
                      child: Text(
                        "${hargaBarang.format(_listBarang[index].harga * 10)}",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        shrinkWrap: true,
        itemCount: _listBarang.length,
      ),
    );
  }
}
