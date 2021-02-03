// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

import 'package:kopbi/src/models/usersDetailsModel.dart';

MessageModelNew messageModelNewFromJson(String str) =>
    MessageModelNew.fromJson(json.decode(str));

String messageModelNewToJson(MessageModelNew data) =>
    json.encode(data.toJson());

class MessageModelNew {
  bool success;
  String message;
  DataModel data;

  MessageModelNew({
    this.success,
    this.message,
    this.data,
  });

  factory MessageModelNew.fromJson(Map<String, dynamic> json) =>
      MessageModelNew(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : DataModel.fromJson(jsonDecode(json["data"])),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.data,
      };
}

DataModel dataModelFromJson(String str) =>
    DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) =>
    json.encode(data.toJson());

class DataModel {
  int totalRow;
  int mulai;
  int akhir;
  String data;

  DataModel({this.totalRow, this.mulai, this.akhir, this.data});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    totalRow: json["totalRow"] == null ? null : json["totalRow"],
    mulai: json["mulai"] == null ? null : json["mulai"],
    akhir: json["akhir"] == null ? null : json["akhir"],
    data: json["data"] == null ? null : jsonEncode(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "totalRow": totalRow == null ? null : totalRow,
    "mulai": mulai == null ? null : mulai,
    "akhir": akhir == null ? null : akhir,
    "data": data == null ? null : data,
  };
}
