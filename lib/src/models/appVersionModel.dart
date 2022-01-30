// To parse this JSON data, do
//
//     final appVersion = appVersionFromJson(jsonString);

import 'dart:convert';

List<AppVersion> appVersionFromJson(String str) => List<AppVersion>.from(json.decode(str).map((x) => AppVersion.fromJson(x)));

String appVersionToJson(List<AppVersion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppVersion {
  String id;
  String kode;
  String keterangan;
  String tipe;
  String nominal;

  AppVersion({
    this.id,
    this.kode,
    this.keterangan,
    this.tipe,
    this.nominal,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
    id: json["id"] == null ? null : json["id"],
    kode: json["kode"] == null ? null : json["kode"],
    keterangan: json["keterangan"] == null ? null : json["keterangan"],
    tipe: json["tipe"] == null ? null : json["tipe"],
    nominal: json["nominal"] == null ? null : json["nominal"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "kode": kode == null ? null : kode,
    "keterangan": keterangan == null ? null : keterangan,
    "tipe": tipe == null ? null : tipe,
    "nominal": nominal == null ? null : nominal,
  };
}
