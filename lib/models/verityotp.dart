// To parse this JSON data, do
//
//     final verifyOtp = verifyOtpFromJson(jsonString);

import 'dart:convert';

VerifyOtp verifyOtpFromJson(String str) => VerifyOtp.fromJson(json.decode(str));

String verifyOtpToJson(VerifyOtp data) => json.encode(data.toJson());

class VerifyOtp {
  VerifyOtp({
    required this.code,
    required this.message,
    required this.userId,
    required this.email,
  });

  int code;
  String message;
  String userId;
  String email;

  factory VerifyOtp.fromJson(Map<String, dynamic> json) => VerifyOtp(
        code: json["code"],
        message: json["message"],
        userId: json["user_id"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "user_id": userId,
        "email": email,
      };
}
