import 'package:flutter/material.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:kopbi/src/views/isiulang_screen/list_pengajuan_penarikan.dart';

class AddPengajuanKreditKendaraan extends StatefulWidget {
  @override
  _AddPengajuanKreditKendaraanState createState() => _AddPengajuanKreditKendaraanState();
}

class _AddPengajuanKreditKendaraanState extends State<AddPengajuanKreditKendaraan> {

  final List<FilterGroup> _filterList = [
    FilterGroup(index: 3, text: "Batal"),
    FilterGroup(index: 4, text: "Selesai"),
    FilterGroup(index: 5, text: "Ditolak HRD"),
    FilterGroup(index: 6, text: "Ditolak Pengawas"),
  ];

  int _filterIndex = -1;
  String selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Center(
              child: Text(
                'Belum ada pengajuan Kredit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black45,
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: 100,
                child: FlatButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.filter_list),
                      Spacer(),
                      Text("Filter")
                    ],
                  ),
                  onPressed: () {
                    filterSheet();
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  void filterSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                          Text("Filter Kendaraan", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _filterIndex = -1;
                                });
                              },
                              child: Text("Reset"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        children: _filterList.map((e) =>
                            Row(
                              children: <Widget>[
                                Text(e.text),
                                Spacer(),
                                Radio(
                                  value: e.index,
                                  groupValue: _filterIndex,
                                  materialTapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap,
                                  onChanged: (value) {
                                    setState(() {
                                      _filterIndex = value;
                                      selectedFilter = e.text;

                                      print(_filterIndex);
                                      print(selectedFilter);
                                    });
                                  },
                                )
                              ],
                            )).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(),
                    ),
                    Container(
                      width: screenWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Terapkan"),
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }
}
