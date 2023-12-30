// To parse this JSON data, do
//
//     final bookRide = bookRideFromJson(jsonString);

import 'dart:convert';

BookRide bookRideFromJson(String str) => BookRide.fromJson(json.decode(str));

String bookRideToJson(BookRide data) => json.encode(data.toJson());

class BookRide {
  int code;
  String message;
  String bookingNumber;

  BookRide({
    required this.code,
    required this.message,
    required this.bookingNumber,
  });

  factory BookRide.fromJson(Map<String, dynamic> json) => BookRide(
        code: json["code"],
        message: json["message"],
        bookingNumber: json["booking_number"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "booking_number": bookingNumber,
      };
}
