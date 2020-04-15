import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopbi/src/config/preferences.dart';
import 'package:kopbi/src/utils/screenSize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahDataAnggotaScreen extends StatefulWidget {
  @override
  _UbahDataAnggotaScreenState createState() => _UbahDataAnggotaScreenState();
}

class _UbahDataAnggotaScreenState extends State<UbahDataAnggotaScreen> {
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

  String kodeAnggota;
  String nomorAnggota;
  String kodePerusahaan;
  String alamatPerusahaan;
  String kodeJabatan;
  String namaJabatan;
  String kodeBank;
  String tglRegistrasi;
  String statusAnggota;
  String role;
  String kodeFederasi;
  String emailPerusahaan;
  String jenisKelamin;
  String statusPernikahan;
  String pendapatanPerbulan;
  String token;

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

  void getPreferences() async {
    SharedPreferences value = await SharedPreferences.getInstance();

    setState(() {
      namaLengkapCrtl.text = value.getString(NAMA_ANGGOTA);
      nomorKtpCtrl.text = value.getString(NO_KTP);
      jenisKelamin = value.getString(JENIS_KELAMIN);
      tempatLahirCtrl.text = value.getString(TEMPAT_LAHIR);
      tanggalLahirCtrl.text = value.getString(TANGGAL_LAHIR);
      statusPernikahan = value.getString(STATUS_PERKAWINAN);
      alamatCtrl.text = value.getString(ALAMAT);
      pekerjaanCtrl.text = value.getString(PEKERJAAN);
      alamatEmailCtrl.text = value.getString(EMAIL_PRIBADI);
      nomorHpCtrl.text = value.getString(CONTACT_ANGGOTA);

      konfederasiCtrl.text = value.getString(NAMA_KONFEDERENSI);
      namaPerusahaanCtrl.text = value.getString(NAMA_PERUSAHAAN);
      namaPenempatanCtrl.text = value.getString(LOKASI_PENEMPATAN);
      nomorNIKCtrl.text = value.getString(NIK);
      jabatanCtrl.text = value.getString(JABATAN_KEANGGOTAAN);
      pendapatanPerbulan = value.getString(PENDAPATAN);

      namaSaudaraCtrl.text = value.getString(NAMA_SAUDARA_DEKAT);
      hubunganSaudaraCtrl.text = value.getString(HUBUNGAN_SAUDARA);
      alamatSaudaraCtrl.text = value.getString(ALAMAT_SAUDARA);
      nomorHpSaudaraCtrl.text = value.getString(NO_HP_SAUDARA);

      namaBankCtrl.text = value.getString(NAMA_BANK);
      cabangBankCtrl.text = value.getString(CABANG_BANK);
      norekCtrl.text = value.getString(NOMOR_REKENING);

      simpananWajibBulananCtrl.text = value.getString(SIMPANAN_WAJIB);
      simpananSukarelaBulananCtrl.text = value.getString(SIMPANAN_SUKARELA);

      token = value.getString(JWT_TOKEN);
      kodeAnggota = value.getString(KODE_USER);
      nomorAnggota = value.getString(NOMOR_ANGGOTA);
      kodePerusahaan = value.getString(KODE_PERUSAHAAN);
      alamatPerusahaan = value.getString(ALAMAT_PERUSAHAAN);
      emailPerusahaan = value.getString(EMAIL_PERUSAHAAN);
      kodeJabatan = value.getString(KODE_JABATAN);
      namaJabatan = value.getString(NAMA_JABATAN);
      kodeBank = value.getString(KODE_BANK);
      tglRegistrasi = value.getString(TGL_REGISTRASI);
      statusAnggota = value.getString(STATUS_ANGGOTA);
      role = value.getString(ROLE);
      kodeFederasi = value.getString(KODE_FEDERASI);
    });
  }

  void simpanPerubahan() async {
    SharedPreferences value = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    Dio _dio = new Dio();

    var response =
        await _dio.post("http://solusi.kopbi.or.id/api/kopbi-agt/post-anggota",
            options: Options(headers: {
              'token': 'U2FsdGVkX19emypgqSLb6nLxUO5CO3eG7avTQXU045E=',
              'jwtToken': token,
              'Content-Type': 'application/json'
            }),
            data: {
          "kodeAnggota": kodeAnggota,
          "nomorAnggota": nomorAnggota,
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
          "kodePerusahaan": kodePerusahaan,
          "namaPerusahaan": namaPerusahaanCtrl.text,
          "alamatPerusahaan": alamatPerusahaan,
          "emailPerusahaan": emailPerusahaan,
          "lokasiPenempatan": namaPenempatanCtrl.text,
          "kodeJabatan": kodeJabatan,
          "namaJabatan": namaJabatan,
          "kodeBank": kodeBank,
          "namaBank": namaBankCtrl.text,
          "cabangBank": cabangBankCtrl.text == null ? "-" : cabangBankCtrl.text,
          "nomorRekening": norekCtrl.text,
          "tanggalRegistrasi": tglRegistrasi,
          "password": null,
          "statusAnggota": statusAnggota,
          "role": role,
          "kodeKonfederasi": kodeFederasi,
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
    if (response.statusCode == 200) {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      setState(() {
        isLoading = false;
        setState(() {
          value.setString(NAMA_ANGGOTA, namaLengkapCrtl.text);
          value.setString(NO_KTP, nomorKtpCtrl.text);
          value.setString(JENIS_KELAMIN, jenisKelamin);
          value.setString(TEMPAT_LAHIR, tempatLahirCtrl.text);
          value.setString(TANGGAL_LAHIR, tanggalLahirCtrl.text);
          value.setString(STATUS_PERKAWINAN, statusPernikahan);
          value.setString(ALAMAT, alamatCtrl.text);
          value.setString(PEKERJAAN, pekerjaanCtrl.text);
          value.setString(EMAIL_PRIBADI, alamatEmailCtrl.text);
          value.setString(CONTACT_ANGGOTA, nomorHpCtrl.text);

          value.setString(NAMA_KONFEDERENSI, konfederasiCtrl.text);
          value.setString(NAMA_PERUSAHAAN, namaPerusahaanCtrl.text);
          value.setString(LOKASI_PENEMPATAN, namaPenempatanCtrl.text);
          value.setString(NIK, nomorNIKCtrl.text);
          value.setString(JABATAN_KEANGGOTAAN, jabatanCtrl.text);
          value.setString(PENDAPATAN, pendapatanPerbulan);

          value.setString(NAMA_SAUDARA_DEKAT, namaSaudaraCtrl.text);
          value.setString(HUBUNGAN_SAUDARA, hubunganSaudaraCtrl.text);
          value.setString(ALAMAT_SAUDARA, alamatSaudaraCtrl.text);
          value.setString(NO_HP_SAUDARA, nomorHpSaudaraCtrl.text);

          value.setString(NAMA_BANK, namaBankCtrl.text);
          value.setString(CABANG_BANK, cabangBankCtrl.text);
          value.setString(NOMOR_REKENING, norekCtrl.text);

          value.setString(SIMPANAN_WAJIB, simpananWajibBulananCtrl.text);
          value.setString(SIMPANAN_SUKARELA, simpananSukarelaBulananCtrl.text);
        });

        Navigator.pop(context, 'success');
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green,
        title: Text(
          'Ubah Data Anggota',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
              child: Text(
                "Data Pribadi Anggota",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ),
            formNamaLengkap(),
            formNomorKtp(),
            formJenisKelamin(),
            formTempatLahir(),
            formTanggalLahir(),
            formStatusPernikahan(),
            formAlamat(),
            formPekerjaan(),
            formAlamatEmail(),
            formNomorHp(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
              child: Text(
                "Data Pekerjaan Anggota",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ),
            formKonfederasi(),
            formNamaPerusahaan(),
            formNamaPenempatan(),
            formNomorNIK(),
            formJabatan(),
            formPendapatan(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
              child: Text(
                "Data Saudara Dekat",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ),
            formNamaSaudara(),
            formHubunganSaudara(),
            formAlamatSaudara(),
            formNomorHp(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
              child: Text(
                "Data Rekening Anggota",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ),
            formNamaBank(),
            formCabangBank(),
            formNorek(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
              child: Text(
                "Data Permintaan Simpanan",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ),
            formSimpananWajib(),
            formSimpananSukarela(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          "Simpan Perubahan",
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
    );
  }

  Widget formNamaLengkap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Nama Lengkap (*)',
          hasFloatingPlaceholder: true,
        ),
        controller: namaLengkapCrtl,
      ),
    );
  }

  Widget formNomorKtp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Nomor KTP (*)',
          hasFloatingPlaceholder: true,
        ),
        controller: nomorKtpCtrl,
      ),
    );
  }

  Widget formJenisKelamin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Jenis Kelamin',
              hasFloatingPlaceholder: true,
            ),
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
                items: <String>['Laki-Laki', 'Perempuan']
                    .map<DropdownMenuItem<String>>((String value) {
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
    );
  }

  Widget formTempatLahir() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Tempat Lahir',
          hasFloatingPlaceholder: true,
          errorText: tempatLahirCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: tempatLahirCtrl,
      ),
    );
  }

  Widget formTanggalLahir() {
    return GestureDetector(
      onTap: () {
        _selectedDate(context);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal Lahir',
              hasFloatingPlaceholder: true,
              errorText: tanggalLahirCtrl.text.isEmpty ? 'Wajib diisi' : null
            ),
            controller: tanggalLahirCtrl,
          ),
        ),
      ),
    );
  }

  Widget formStatusPernikahan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Status Pernikahan',
              hasFloatingPlaceholder: true,
            ),
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
                items: <String>['Menikah', 'Belum Menikah']
                    .map<DropdownMenuItem<String>>((String value) {
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
    );
  }

  Widget formAlamat() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Alamat',
          hasFloatingPlaceholder: true,
          errorText: alamatCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: alamatCtrl,
        maxLines: null,
      ),
    );
  }

  Widget formPekerjaan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Pekerjaan',
          hasFloatingPlaceholder: true,
          errorText: pekerjaanCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: pekerjaanCtrl,
      ),
    );
  }

  Widget formAlamatEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Alamat Email',
          hasFloatingPlaceholder: true,
          errorText: alamatEmailCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: alamatEmailCtrl,
      ),
    );
  }

  Widget formNomorHp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Nomor Hp (*)',
          hasFloatingPlaceholder: true,
        ),
        controller: nomorHpCtrl,
      ),
    );
  }

  Widget formKonfederasi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Konfederasi / Serikat Kerja (*)',
          hasFloatingPlaceholder: true,
        ),
        controller: konfederasiCtrl,
      ),
    );
  }

  Widget formNamaPerusahaan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Nama Perusahaan (*)',
          hasFloatingPlaceholder: true,
        ),
        controller: namaPerusahaanCtrl,
      ),
    );
  }

  Widget formNamaPenempatan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Nama Penempatan',
          hasFloatingPlaceholder: true,
          errorText: namaPenempatanCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: namaPenempatanCtrl,
      ),
    );
  }

  Widget formNomorNIK() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Nomor NIK (*)',
          hasFloatingPlaceholder: true,
        ),
        controller: nomorNIKCtrl,
      ),
    );
  }

  Widget formJabatan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Jabatan',
          hasFloatingPlaceholder: true,
          errorText: jabatanCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: jabatanCtrl,
      ),
    );
  }

  Widget formPendapatan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Pendapatan Bulanan',
              hasFloatingPlaceholder: true,
            ),
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
                items: <String>['Dibawah Rp.5Jt', '> Rp.5 s/d Rp.10Jt', '> Rp.10Jt s/d Rp.20Jt', 'Diatas Rp.20Jt']
                    .map<DropdownMenuItem<String>>((String value) {
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
    );
  }

  Widget formNamaSaudara() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Nama Saudara',
          hasFloatingPlaceholder: true,
          errorText: namaSaudaraCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: namaSaudaraCtrl,
      ),
    );
  }

  Widget formHubunganSaudara() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Hubungan Saudara',
          hasFloatingPlaceholder: true,
          errorText: hubunganSaudaraCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: hubunganSaudaraCtrl,
      ),
    );
  }

  Widget formAlamatSaudara() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Alamat Saudara',
          hasFloatingPlaceholder: true,
          errorText: alamatSaudaraCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: alamatSaudaraCtrl,
      ),
    );
  }

  Widget formNoHpSaudara() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Nomor Hp Saudara',
          hasFloatingPlaceholder: true,
          errorText: nomorHpSaudaraCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: nomorHpSaudaraCtrl,
      ),
    );
  }

  Widget formNamaBank() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Nama Bank',
          hasFloatingPlaceholder: true,
          errorText: namaBankCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: namaBankCtrl,
      ),
    );
  }

  Widget formCabangBank() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Cabang Pembuka',
          hasFloatingPlaceholder: true,
          errorText: cabangBankCtrl.text.isEmpty ? 'Wajib diisi' : null
        ),
        controller: cabangBankCtrl,
      ),
    );
  }

  Widget formNorek() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          labelText: 'Nomor Rekening',
          hasFloatingPlaceholder: true,
          errorText: norekCtrl.text.isEmpty ? 'Wajib diisi' : null,
        ),
        controller: norekCtrl,
      ),
    );
  }

  Widget formSimpananWajib() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Simpanan Wajib Bulanan',
          hasFloatingPlaceholder: true,
        ),
        controller: simpananWajibBulananCtrl,
      ),
    );
  }

  Widget formSimpananSukarela() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Simpanan Sukarela Bulanan',
          hasFloatingPlaceholder: true,
        ),
        controller: simpananSukarelaBulananCtrl,
      ),
    );
  }
}
