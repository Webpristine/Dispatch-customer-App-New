// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    required this.code,
    required this.message,
    required this.otp,
  });

  int code;
  String message;
  int otp;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        code: json["code"],
        message: json["message"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "otp": otp,
      };
}
