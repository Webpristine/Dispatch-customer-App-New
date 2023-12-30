// To parse this JSON data, do
//
//     final confirmRide = confirmRideFromJson(jsonString);

import 'dart:convert';

ConfirmRide confirmRideFromJson(String str) =>
    ConfirmRide.fromJson(json.decode(str));

String confirmRideToJson(ConfirmRide data) => json.encode(data.toJson());

class ConfirmRide {
  int code;
  String message;
  int bookingNumber;
  String amount;
  String timing;

  ConfirmRide({
    required this.code,
    required this.message,
    required this.bookingNumber,
    required this.amount,
    required this.timing,
  });

  factory ConfirmRide.fromJson(Map<String, dynamic> json) => ConfirmRide(
        code: json["code"],
        message: json["message"],
        bookingNumber: json["booking_number"],
        amount: json["amount"].toString(),
        timing: json["timing"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "booking_number": bookingNumber,
        "amount": amount,
        "timing": timing,
      };
}
