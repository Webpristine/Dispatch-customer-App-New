// To parse this JSON data, do
//
//     final errorCode = errorCodeFromJson(jsonString);

import 'dart:convert';

ErrorCode errorCodeFromJson(String str) => ErrorCode.fromJson(json.decode(str));

String errorCodeToJson(ErrorCode data) => json.encode(data.toJson());

class ErrorCode {
  ErrorCode({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory ErrorCode.fromJson(Map<String, dynamic> json) => ErrorCode(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
