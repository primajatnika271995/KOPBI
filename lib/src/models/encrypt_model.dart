// To parse this JSON data, do
//
//     final encryptModel = encryptModelFromJson(jsonString);

import 'dart:convert';

EncryptModel encryptModelFromJson(String str) => EncryptModel.fromJson(json.decode(str));

String encryptModelToJson(EncryptModel data) => json.encode(data.toJson());

class EncryptModel {
  int status;
  dynamic error;
  String response;

  EncryptModel({
    this.status,
    this.error,
    this.response,
  });

  factory EncryptModel.fromJson(Map<String, dynamic> json) => EncryptModel(
    status: json["status"] == null ? null : json["status"],
    error: json["error"],
    response: json["response"] == null ? null : json["response"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "error": error,
    "response": response == null ? null : response,
  };
}
