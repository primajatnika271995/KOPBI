import 'package:flutter/material.dart';
import 'package:kopbi/src/services/pinjaman.dart';

class HistoriAngsuran extends StatefulWidget {
  Pinjaman pinjaman;

  HistoriAngsuran({
    this.pinjaman
  });

  @override
  _HistoriAngsuranState createState() => _HistoriAngsuranState();
}

class _HistoriAngsuranState extends State<HistoriAngsuran> {

  String dateFormat(DateTime dateTime) {
    if (dateTime == null) return '';

    var a = dateTime.day;

    String date = a.toString();

    if (date.length == 1) date = "0$date";

    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return date +
        ' ' +
        months[(dateTime.month - 1)] +
        ' ' +
        dateTime.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Histori Pengajuan',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tanggal Pengajuan',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${dateFormat(widget.pinjaman.tanggalPengajuan)}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tanggal Pencairan',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${dateFormat(widget.pinjaman.tanggalUpdate)}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pokok Pinjaman',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.formattedNominalPinjaman}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Lama Angsuran',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.lamaAngsuran} bulan',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Bagi Hasil',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.persenBungaOri} %',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pokok Angsuran',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.formattedPokokAngsuran}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Lama Angsuran',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.lamaAngsuran} bulan',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Bagi Hasil',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.formattedBagiHasil}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Biaya Admin',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.formattedBiayaAdmin}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Total Angsuran Perbulan',
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              '${widget.pinjaman.formattedNominalAngsuran}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
