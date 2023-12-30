// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  int code;
  String message;
  List<AddressElement> address;

  Address({
    required this.code,
    required this.message,
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        code: json["code"],
        message: json["message"],
        address: List<AddressElement>.from(
            json["address"].map((x) => AddressElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "address": List<dynamic>.from(address.map((x) => x.toJson())),
      };
}

class AddressElement {
  String addressLine1;
  String addressLine2;
  String latitude;
  String longitude;
  String? placeId;

  AddressElement(
      {required this.addressLine1,
      required this.addressLine2,
      required this.latitude,
      required this.longitude,
      this.placeId});

  factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "latitude": latitude,
        "longitude": longitude,
        "place_id": placeId
      };
}
