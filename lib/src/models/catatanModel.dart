// To parse this JSON data, do
//
//     final catatanModel = catatanModelFromJson(jsonString);

import 'dart:convert';

CatatanModel catatanModelFromJson(String str) => CatatanModel.fromJson(json.decode(str));

String catatanModelToJson(CatatanModel data) => json.encode(data.toJson());

class CatatanModel {
  bool success;
  String message;
  List<Datum> data;

  CatatanModel({
    this.success,
    this.message,
    this.data,
  });

  factory CatatanModel.fromJson(Map<String, dynamic> json) => CatatanModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  int id;
  String kodeKategori;
  String catatan;
  String namaKategori;
  String namaKonten;
  String aktif;
  String keterangan;

  Datum({
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.id,
    this.kodeKategori,
    this.catatan,
    this.namaKategori,
    this.namaKonten,
    this.aktif,
    this.keterangan,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
    updatedDate: json["updatedDate"] == null ? null : json["updatedDate"],
    id: json["id"] == null ? null : json["id"],
    kodeKategori: json["kodeKategori"] == null ? null : json["kodeKategori"],
    catatan: json["catatan"] == null ? null : json["catatan"],
    namaKategori: json["namaKategori"] == null ? null : json["namaKategori"],
    namaKonten: json["namaKonten"] == null ? null : json["namaKonten"],
    aktif: json["aktif"] == null ? null : json["aktif"],
    keterangan: json["keterangan"] == null ? null : json["keterangan"],
  );

  Map<String, dynamic> toJson() => {
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "updatedBy": updatedBy == null ? null : updatedBy,
    "updatedDate": updatedDate == null ? null : updatedDate,
    "id": id == null ? null : id,
    "kodeKategori": kodeKategori == null ? null : kodeKategori,
    "catatan": catatan == null ? null : catatan,
    "namaKategori": namaKategori == null ? null : namaKategori,
    "namaKonten": namaKonten == null ? null : namaKonten,
    "aktif": aktif == null ? null : aktif,
    "keterangan": keterangan == null ? null : keterangan,
  };
}
