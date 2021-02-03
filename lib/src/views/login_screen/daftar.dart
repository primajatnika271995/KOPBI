import 'dart:convert';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/models/message_model.dart';
import 'package:kopbi/src/utils/screenSize.dart';

class DaftarScreen extends StatefulWidget {
  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  var namaLengkapCrtl = new TextEditingController();
  var nomorKtpCtrl = new TextEditingController();
  var tempatLahirCtrl = new TextEditingController();
  var tanggalLahirCtrl = new TextEditingController();
  var alamatCtrl = new TextEditingController();
  var pekerjaanCtrl = new TextEditingController();
  var alamatEmailCtrl = new TextEditingController();
  var nomorHpCtrl = new TextEditingController();

  var konfederasiCtrl = new TextEditingController();
  var namaPerusahaanCtrl = new TextEditingController();
  var namaPenempatanCtrl = new TextEditingController();
  var nomorNIKCtrl = new TextEditingController();
  var jabatanCtrl = new TextEditingController();

  var namaSaudaraCtrl = new TextEditingController();
  var hubunganSaudaraCtrl = new TextEditingController();
  var alamatSaudaraCtrl = new TextEditingController();
  var nomorHpSaudaraCtrl = new TextEditingController();

  var namaBankCtrl = new TextEditingController();
  var cabangBankCtrl = new TextEditingController();
  var norekCtrl = new TextEditingController();

  var simpananWajibBulananCtrl = new TextEditingController();
  var simpananSukarelaBulananCtrl = new TextEditingController();

  String jenisKelamin;
  String statusPernikahan;
  String pendapatanPerbulan;

  final dateFormat = DateFormat("yyyy-MM-dd");

  DateTime _dateTime = DateTime.now();

  bool isLoading = false;

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(1700, 1),
      lastDate: DateTime(2100),
    );

    if (picked != null)
      setState(() {
        _dateTime = picked;
        tanggalLahirCtrl.value =
            TextEditingValue(text: dateFormat.format(picked).toString());
      });
  }

  void simpanPerubahan() async {
    print("Nama Lengkap  ${namaLengkapCrtl.text}");
    print("nomorKtp  ${nomorKtpCtrl.text}");
    print("nomorNIKCtrl  ${nomorNIKCtrl.text}");
    print("jenisKelamin  ${jenisKelamin}");
    print("tempatLahirCtrl  ${tempatLahirCtrl.text}");
    print("tanggalLahirCtrl  ${tanggalLahirCtrl.text}");
    print("statusPernikahan  ${statusPernikahan}");
    print("pekerjaanCtrl  ${pekerjaanCtrl.text}");
    print("alamat  ${alamatCtrl.text}");
    print("nomorHpCtrl  ${nomorHpCtrl.text}");
    print("namaPerusahaanCtrl  ${namaPerusahaanCtrl.text}");
    print("namaPenempatanCtrl  ${namaPenempatanCtrl.text}");
    print("namaBankCtrl  ${namaBankCtrl.text}");
    print("cabangBankCtrl  ${cabangBankCtrl.text}");
    print("norekCtrl  ${norekCtrl.text}");
    print("konfederasiCtrl  ${konfederasiCtrl.text}");
    print("alamatEmailCtrl  ${alamatEmailCtrl.text}");
    print("namaSaudaraCtrl  ${namaSaudaraCtrl.text}");
    print("hubunganSaudaraCtrl  ${hubunganSaudaraCtrl.text}");
    print("alamatSaudaraCtrl  ${alamatSaudaraCtrl.text}");
    print("nomorHpSaudaraCtrl  ${nomorHpSaudaraCtrl.text}");
    print("pendapatanPerbulan  ${pendapatanPerbulan}");
    print("simpananWajibBulananCtrl  ${simpananWajibBulananCtrl.text}");
    print("simpananSukarelaBulananCtrl  ${simpananSukarelaBulananCtrl.text}");
    print("jabatanCtrl  ${jabatanCtrl.text}");

    if (_formKey5.currentState.validate()) {
      Dio _dio = new Dio();
      var response =
      await _dio.post("http://solusi.kopbi.or.id/api/registrasi-anggota",
          options: Options(headers: {
            'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
            'Content-Type': 'application/json'
          }),
          data: {
            "kodeAnggota": "",
            "nomorAnggota": "",
            "nama": namaLengkapCrtl.text,
            "nomorKtp": nomorKtpCtrl.text,
            "nomorNik": nomorNIKCtrl.text,
            "jenisKelamin": jenisKelamin,
            "tempatLahir": tempatLahirCtrl.text,
            "tanggalLahir": tanggalLahirCtrl.text,
            "status": statusPernikahan,
            "pekerjaan": pekerjaanCtrl.text,
            "alamat": alamatCtrl.text,
            "nomorHp": nomorHpCtrl.text,
            "kodePerusahaan": "PRBD",
            "namaPerusahaan": namaPerusahaanCtrl.text,
            "alamatPerusahaan": "",
            "emailPerusahaan": "",
            "lokasiPenempatan": namaPenempatanCtrl.text,
            "kodeJabatan": "",
            "namaJabatan": "-",
            "kodeBank": "",
            "namaBank": namaBankCtrl.text,
            "cabangBank": cabangBankCtrl.text == null ? "-" : cabangBankCtrl.text,
            "nomorRekening": norekCtrl.text,
            "tanggalRegistrasi": "",
            "password": "",
            "statusAnggota": "REG",
            "role": "AGT",
            "kodeKonfederasi": "",
            "namaKonfederasi": konfederasiCtrl.text,
            "emailPribadi": alamatEmailCtrl.text,
            "namaSaudaraDekat": namaSaudaraCtrl.text,
            "hubunganSaudara": hubunganSaudaraCtrl.text,
            "alamatSaudara": alamatSaudaraCtrl.text,
            "nomorHpSaudara": nomorHpSaudaraCtrl.text,
            "pendapatan": pendapatanPerbulan,
            "simpananWajib": simpananWajibBulananCtrl.text,
            "simpananSukarela": simpananSukarelaBulananCtrl.text,
            "jabatanKeanggotaan": jabatanCtrl.text
          });

      print("Simpan Data Response : ${response.statusCode}");
      print("Simpan Data Response : ${response.data}");

      MessageModel value = messageModelFromJson(json.encode(response.data));

      if (response.statusCode == 200 && value.success == true) {
        setState(() {
          isLoading = false;
        });

        showDialog(
            context: context,
          barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Registasi Berhasil",
                  style: TextStyle(
                      color: Colors.lightGreen),
                ),
                content: Text(
                    "Silahkan cek Email untuk melakukan verifikasi."),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text("Selesai")),
                ],
              );
            });
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Gagal Registrasi Data, data sudah terdaftar!'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Harap isi semua data'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text(
          'Daftar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: CoolStepper(
        onCompleted: () {
          print("Steps completed!");
        },
        config: CoolStepperConfig(
          backText: "PREV",
        ),
        steps: [
          CoolStep(
              title: "Data Pribadi",
              subtitle:
              "Silahkan lengkapi data pribadi anda, sebelum melanjutkan ke tahap selanjutnya.",
              content: Form(
                key: _formKey1,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: nomorKtpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Nomor KTP',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nomor KTP wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: namaLengkapCrtl,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nama Lengkap wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Jenis Kelamin',
                                floatingLabelBehavior:
                                FloatingLabelBehavior.auto,
                                prefixIcon: Icon(Icons.nature_people)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: jenisKelamin,
                                isExpanded: true,
                                isDense: true,
                                icon: Icon(Icons.arrow_drop_down),
                                onChanged: (String newValue) {
                                  setState(() {
                                    jenisKelamin = newValue;
                                  });
                                },
                                items: <String>[
                                  'Laki-Laki',
                                  'Perempuan'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: tempatLahirCtrl,
                        decoration: InputDecoration(
                          labelText: 'Tempat Lahir',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Tempat Lahir wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          _selectedDate(context);
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            readOnly: true,
                            controller: tanggalLahirCtrl,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Lahir',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Tanggal Lahir wajib diisi.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Status Pernikahan',
                                floatingLabelBehavior:
                                FloatingLabelBehavior.auto,
                                prefixIcon: Icon(Icons.assistant)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: statusPernikahan,
                                isExpanded: true,
                                isDense: true,
                                icon: Icon(Icons.arrow_drop_down),
                                onChanged: (String newValue) {
                                  setState(() {
                                    statusPernikahan = newValue;
                                  });
                                },
                                items: <String>[
                                  'Menikah',
                                  'Belum Menikah'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: alamatCtrl,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Alamat wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: pekerjaanCtrl,
                        decoration: InputDecoration(
                          labelText: 'Pekerjaan',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.gavel),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Pekerjaan wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: alamatEmailCtrl,
                        decoration: InputDecoration(
                          labelText: 'Alamat Email',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Alamat Email wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: TextFormField(
                        controller: nomorHpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Nomor HP',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nomor HP wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              validation: () {
                if (!_formKey1.currentState.validate()) {
                  return "Fill form correctly";
                }
                return null;
              }),
//          STEP 2
          CoolStep(
              title: "Data Pekerjaan Anggota",
              subtitle:
              "Silahkan lengkapi data pekerjaan anda, sebelum melanjutkan ke tahap selanjutnya.",
              content: Form(
                key: _formKey2,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: konfederasiCtrl,
                        decoration: InputDecoration(
                          labelText: 'Konfederasi Serikat Kerja',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.domain),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Konfederasi wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: namaPerusahaanCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nama Perusahaan',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.domain),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nama Perusahaan wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: namaPenempatanCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nama Penempatan',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.local_activity),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nama Penempatan wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: nomorNIKCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Nomor NIK',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nomor NIK wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: jabatanCtrl,
                        decoration: InputDecoration(
                          labelText: 'Jabatan',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.assistant),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Jabatan wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Pendapatan Bulanan',
                                floatingLabelBehavior:
                                FloatingLabelBehavior.auto,
                                prefixIcon: Icon(Icons.attach_money)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: pendapatanPerbulan,
                                isExpanded: true,
                                isDense: true,
                                icon: Icon(Icons.arrow_drop_down),
                                onChanged: (String newValue) {
                                  setState(() {
                                    pendapatanPerbulan = newValue;
                                  });
                                },
                                items: <String>[
                                  'Dibawah Rp.5Jt',
                                  '> Rp.5 s/d Rp.10Jt',
                                  '> Rp.10Jt s/d Rp.20Jt',
                                  'Diatas Rp.20Jt'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              validation: () {
                if (!_formKey2.currentState.validate()) {
                  return "Fill form correctly";
                }
                return null;
              }),
//          STEP 3
          CoolStep(
              title: "Data Saudara Dekat",
              subtitle:
              "Silahkan lengkapi data saudara dekat anda, sebelum melanjutkan ke tahap selanjutnya.",
              content: Form(
                key: _formKey3,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: namaSaudaraCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nama Saudara',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nama Saudara wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: hubunganSaudaraCtrl,
                        decoration: InputDecoration(
                          labelText: 'Hubungan Saudara',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.info),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Hubungan Saudara wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: alamatSaudaraCtrl,
                        decoration: InputDecoration(
                          labelText: 'Alamat Saudara',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.local_activity),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Alamat Saudara wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: nomorHpSaudaraCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Nomor HP Saudara',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nomor HP Saudara wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              validation: () {
                if (!_formKey3.currentState.validate()) {
                  return "Fill form correctly";
                }
                return null;
              }),
//          STEP 4
          CoolStep(
              title: "Data Rekening Anggota",
              subtitle:
              "Silahkan lengkapi data rekening anda, sebelum melanjutkan ke tahap selanjutnya.",
              content: Form(
                key: _formKey4,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: namaBankCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nama BANK',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.info),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nama Bank wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: cabangBankCtrl,
                        decoration: InputDecoration(
                          labelText: 'Cabang Pembuka',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.info),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Cabang Bank wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: norekCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Nomor Rekening',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nomor Rekening wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              validation: () {
                if (!_formKey4.currentState.validate()) {
                  return "Fill form correctly";
                }
                return null;
              }),
//          STEP 5
          CoolStep(
              title: "Data Permintaan Simpanan",
              subtitle:
              "Silahkan lengkapi data permintaan simpanan anda, sebelum melanjutkan ke tahap selanjutnya.",
              content: Form(
                key: _formKey5,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: simpananWajibBulananCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Simpanan Wajib Bulanan',
                          prefixIcon: Icon(Icons.info),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Simpanan Wajib harus diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: simpananSukarelaBulananCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Simpanan Sukarela Bulanan',
                          prefixIcon: Icon(Icons.info),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Simpanan Sukarela wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        width: screenWidth(context),
                        child: RaisedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            simpanPerubahan();
                          },
                          child: isLoading
                              ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                              : Text(
                            "Registrasi",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              validation: () {
                if (!_formKey5.currentState.validate()) {
                  return "Fill form correctly";
                }
                return null;
              }),
        ],
      ),
    );
  }
}
