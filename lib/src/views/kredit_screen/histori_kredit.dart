import 'package:flutter/material.dart';

class HistoriPengjuanKredit extends StatefulWidget {
  dynamic tglApproveHrd;
  String namaHrd;
  String catatanHrd;
  dynamic tglApprovePengawas;
  String namaPengawas;
  String catatanPengawas;

  HistoriPengjuanKredit({
    this.tglApproveHrd,
    this.namaHrd,
    this.catatanHrd,
    this.tglApprovePengawas,
    this.namaPengawas,
    this.catatanPengawas,
  });

  @override
  _HistoriPengjuanKreditState createState() => _HistoriPengjuanKreditState();
}

class _HistoriPengjuanKreditState extends State<HistoriPengjuanKredit> {
  @override
  Widget build(BuildContext context) {
    print(widget.catatanPengawas);
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
              'Tanggal Approve HRD',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              widget.tglApproveHrd.toString().length < 1 ? 'Belum Ada' : '${widget.tglApproveHrd}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'NAMA HRD',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              widget.namaHrd.toString().length < 1 ? 'Belum Ada' : '${widget.namaHrd}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Catatan HRD',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              widget.catatanHrd.toString().length < 1 ? 'Belum Ada' : '${widget.catatanHrd}',
              style: TextStyle(fontSize: 14),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tanggal Approve Pengawas',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              widget.tglApprovePengawas.toString().length < 1 ? 'Belum Ada' : '${widget.tglApprovePengawas}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'NAMA Pengawas',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              widget.namaPengawas.toString().length < 1 ? 'Belum Ada' : '${widget.namaPengawas}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Catatan Pengawas',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              widget.catatanPengawas.toString().length < 1 ? 'Belum Ada' : '${widget.catatanPengawas}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
