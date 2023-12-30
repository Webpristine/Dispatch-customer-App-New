// To parse this JSON data, do
//
//     final vehicles = vehiclesFromJson(jsonString);

import 'dart:convert';

Vehicles vehiclesFromJson(String str) => Vehicles.fromJson(json.decode(str));

String vehiclesToJson(Vehicles data) => json.encode(data.toJson());

class Vehicles {
  int code;
  String message;
  List<Vehicle> vehicles;

  Vehicles({
    required this.code,
    required this.message,
    required this.vehicles,
  });

  factory Vehicles.fromJson(Map<String, dynamic> json) => Vehicles(
        code: json["code"],
        message: json["message"],
        vehicles: List<Vehicle>.from(
            json["vehicles"].map((x) => Vehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
      };
}

class Vehicle {
  String vehicleId;
  String vehicleName;
  String vehicleType;
  String vehicleColor;
  String vehicleNumber;

  Vehicle({
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleType,
    required this.vehicleColor,
    required this.vehicleNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleId: json["vehicle_id"],
        vehicleName: json["vehicle_name"],
        vehicleType: json["vehicle_type"],
        vehicleColor: json["vehicle_color"],
        vehicleNumber: json["vehicle_number"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle_id": vehicleId,
        "vehicle_name": vehicleName,
        "vehicle_type": vehicleType,
        "vehicle_color": vehicleColor,
        "vehicle_number": vehicleNumber,
      };
}
