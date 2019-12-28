import 'package:flutter/material.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Prosedur KOPBI',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'Prosedur Peminjaman',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("1."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text("Menggunakan aplikasi KOPBI Solution baik WEB atau ANDROID"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("2."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Status keanggotaan aktif"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("3."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Telah menjadi anggota KOPBI selama 6 bulan dan melakukan simpanan wajib minimal 6 bulan"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("4."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Tidak memiliki pinjaman berjalan / belum lunas"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("5."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Bersedia dipotong gaji oleh perusahaan yang bersangkutan"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("6."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Mematuhi segala persyaratan dan peraturan yang berlaku"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),
            Text(
              'Prosedur Penonaktifan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("1."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text("Menunjukan buku anggota KOPBI"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("2."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Menunjukan KTP Asli"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("3."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Menunjukan surat Paklaring dari perusahaan"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("4."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Tidak memiliki pinjaman berjalan / belum lunas"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text("5."),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Text(
                            "Mematuhi segala persyaratan dan peraturan yang berlaku"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
