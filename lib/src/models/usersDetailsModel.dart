// To parse this JSON data, do
//
//     final usersDetailsModel = usersDetailsModelFromJson(jsonString);

import 'dart:convert';

UsersDetailsModel usersDetailsModelFromJson(String str) => UsersDetailsModel.fromJson(json.decode(str));

String usersDetailsModelToJson(UsersDetailsModel data) => json.encode(data.toJson());

class UsersDetailsModel {
  bool success;
  String message;
  Data data;

  UsersDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  factory UsersDetailsModel.fromJson(Map<String, dynamic> json) => UsersDetailsModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Session session;
  User user;

  Data({
    this.session,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    session: json["session"] == null ? null : Session.fromJson(json["session"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "session": session == null ? null : session.toJson(),
    "user": user == null ? null : user.toJson(),
  };
}

class Session {
  DateTime expiryDate;
  String jwt;

  Session({
    this.expiryDate,
    this.jwt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
    jwt: json["jwt"] == null ? null : json["jwt"],
  );

  Map<String, dynamic> toJson() => {
    "expiryDate": expiryDate == null ? null : expiryDate.toIso8601String(),
    "jwt": jwt == null ? null : jwt,
  };
}

class User {
  dynamic createdBy;
  dynamic createdDate;
  dynamic updatedBy;
  dynamic updatedDate;
  String kodeAnggota;
  String nomorAnggota;
  String nama;
  String nomorKtp;
  String nomorNik;
  String jenisKelamin;
  dynamic tempatLahir;
  String tanggalLahir;
  dynamic status;
  dynamic pekerjaan;
  String alamat;
  String nomorHp;
  String kodePerusahaan;
  String namaPerusahaan;
  String alamatPerusahaan;
  dynamic emailPerusahaan;
  dynamic lokasiPenempatan;
  String kodeJabatan;
  String namaJabatan;
  String kodeBank;
  String namaBank;
  dynamic cabangBank;
  String nomorRekening;
  DateTime tanggalRegistrasi;
  String password;
  String statusAnggota;
  String role;
  String namaKonfederasi;
  dynamic emailPribadi;
  dynamic namaSaudaraDekat;
  dynamic hubunganSaudara;
  dynamic alamatSaudara;
  dynamic nomorHpSaudara;
  dynamic pendapatan;
  dynamic simpananWajib;
  dynamic simpananSukarela;
  dynamic jabatanKeanggotaan;

  User({
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.kodeAnggota,
    this.nomorAnggota,
    this.nama,
    this.nomorKtp,
    this.nomorNik,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.status,
    this.pekerjaan,
    this.alamat,
    this.nomorHp,
    this.kodePerusahaan,
    this.namaPerusahaan,
    this.alamatPerusahaan,
    this.emailPerusahaan,
    this.lokasiPenempatan,
    this.kodeJabatan,
    this.namaJabatan,
    this.kodeBank,
    this.namaBank,
    this.cabangBank,
    this.nomorRekening,
    this.tanggalRegistrasi,
    this.password,
    this.statusAnggota,
    this.role,
    this.namaKonfederasi,
    this.emailPribadi,
    this.namaSaudaraDekat,
    this.hubunganSaudara,
    this.alamatSaudara,
    this.nomorHpSaudara,
    this.pendapatan,
    this.simpananWajib,
    this.simpananSukarela,
    this.jabatanKeanggotaan,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    createdBy: json["createdBy"],
    createdDate: json["createdDate"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
    kodeAnggota: json["kodeAnggota"] == null ? null : json["kodeAnggota"],
    nomorAnggota: json["nomorAnggota"] == null ? null : json["nomorAnggota"],
    nama: json["nama"] == null ? null : json["nama"],
    nomorKtp: json["nomorKtp"] == null ? null : json["nomorKtp"],
    nomorNik: json["nomorNik"] == null ? null : json["nomorNik"],
    jenisKelamin: json["jenisKelamin"] == null ? null : json["jenisKelamin"],
    tempatLahir: json["tempatLahir"],
    tanggalLahir: json["tanggalLahir"] == null ? null : json["tanggalLahir"],
    status: json["status"],
    pekerjaan: json["pekerjaan"],
    alamat: json["alamat"] == null ? null : json["alamat"],
    nomorHp: json["nomorHp"] == null ? null : json["nomorHp"],
    kodePerusahaan: json["kodePerusahaan"] == null ? null : json["kodePerusahaan"],
    namaPerusahaan: json["namaPerusahaan"] == null ? null : json["namaPerusahaan"],
    alamatPerusahaan: json["alamatPerusahaan"] == null ? null : json["alamatPerusahaan"],
    emailPerusahaan: json["emailPerusahaan"],
    lokasiPenempatan: json["lokasiPenempatan"],
    kodeJabatan: json["kodeJabatan"] == null ? null : json["kodeJabatan"],
    namaJabatan: json["namaJabatan"] == null ? null : json["namaJabatan"],
    kodeBank: json["kodeBank"] == null ? null : json["kodeBank"],
    namaBank: json["namaBank"] == null ? null : json["namaBank"],
    cabangBank: json["cabangBank"],
    nomorRekening: json["nomorRekening"] == null ? null : json["nomorRekening"],
    tanggalRegistrasi: json["tanggalRegistrasi"] == null ? null : DateTime.parse(json["tanggalRegistrasi"]),
    password: json["password"] == null ? null : json["password"],
    statusAnggota: json["statusAnggota"] == null ? null : json["statusAnggota"],
    role: json["role"] == null ? null : json["role"],
    namaKonfederasi: json["namaKonfederasi"] == null ? null : json["namaKonfederasi"],
    emailPribadi: json["emailPribadi"],
    namaSaudaraDekat: json["namaSaudaraDekat"],
    hubunganSaudara: json["hubunganSaudara"],
    alamatSaudara: json["alamatSaudara"],
    nomorHpSaudara: json["nomorHpSaudara"],
    pendapatan: json["pendapatan"],
    simpananWajib: json["simpananWajib"],
    simpananSukarela: json["simpananSukarela"],
    jabatanKeanggotaan: json["jabatanKeanggotaan"],
  );

  Map<String, dynamic> toJson() => {
    "createdBy": createdBy,
    "createdDate": createdDate,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "kodeAnggota": kodeAnggota == null ? null : kodeAnggota,
    "nomorAnggota": nomorAnggota == null ? null : nomorAnggota,
    "nama": nama == null ? null : nama,
    "nomorKtp": nomorKtp == null ? null : nomorKtp,
    "nomorNik": nomorNik == null ? null : nomorNik,
    "jenisKelamin": jenisKelamin == null ? null : jenisKelamin,
    "tempatLahir": tempatLahir,
    "tanggalLahir": tanggalLahir == null ? null : tanggalLahir,
    "status": status,
    "pekerjaan": pekerjaan,
    "alamat": alamat == null ? null : alamat,
    "nomorHp": nomorHp == null ? null : nomorHp,
    "kodePerusahaan": kodePerusahaan == null ? null : kodePerusahaan,
    "namaPerusahaan": namaPerusahaan == null ? null : namaPerusahaan,
    "alamatPerusahaan": alamatPerusahaan == null ? null : alamatPerusahaan,
    "emailPerusahaan": emailPerusahaan,
    "lokasiPenempatan": lokasiPenempatan,
    "kodeJabatan": kodeJabatan == null ? null : kodeJabatan,
    "namaJabatan": namaJabatan == null ? null : namaJabatan,
    "kodeBank": kodeBank == null ? null : kodeBank,
    "namaBank": namaBank == null ? null : namaBank,
    "cabangBank": cabangBank,
    "nomorRekening": nomorRekening == null ? null : nomorRekening,
    "tanggalRegistrasi": tanggalRegistrasi == null ? null : "${tanggalRegistrasi.year.toString().padLeft(4, '0')}-${tanggalRegistrasi.month.toString().padLeft(2, '0')}-${tanggalRegistrasi.day.toString().padLeft(2, '0')}",
    "password": password == null ? null : password,
    "statusAnggota": statusAnggota == null ? null : statusAnggota,
    "role": role == null ? null : role,
    "namaKonfederasi": namaKonfederasi == null ? null : namaKonfederasi,
    "emailPribadi": emailPribadi,
    "namaSaudaraDekat": namaSaudaraDekat,
    "hubunganSaudara": hubunganSaudara,
    "alamatSaudara": alamatSaudara,
    "nomorHpSaudara": nomorHpSaudara,
    "pendapatan": pendapatan,
    "simpananWajib": simpananWajib,
    "simpananSukarela": simpananSukarela,
    "jabatanKeanggotaan": jabatanKeanggotaan,
  };
}
