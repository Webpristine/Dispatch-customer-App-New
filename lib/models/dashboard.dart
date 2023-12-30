// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  int code;
  String message;
  List<Driver> topRatedDrivers;
  List<Driver> previousDrivers;
  List<Driver> nearbyDrivers;

  Dashboard({
    required this.code,
    required this.message,
    required this.topRatedDrivers,
    required this.previousDrivers,
    required this.nearbyDrivers,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    final listPrvDriver = json["previous_drivers"] as List;
    List<Driver> prvDriver = [];
    listPrvDriver.forEach((e) {
      if (e['id'] != null) {
        prvDriver.add(Driver.fromJson(e));
      }
    });
    final listRatedDriver = json["top_rated_drivers"] as List;
    List<Driver> topRatedDriver = [];
    listRatedDriver.forEach((e) {
      if (e['id'] != null) {
        topRatedDriver.add(Driver.fromJson(e));
      }
    });
    final listNearByDriver = json["nearby_drivers"] as List;
    List<Driver> listNearDriver = [];
    listNearByDriver.forEach((e) {
      if (e['id'] != null) {
        listNearDriver.add(Driver.fromJson(e));
      }
    });
    return Dashboard(
        code: json["code"],
        message: json["message"],
        topRatedDrivers: topRatedDriver,
        previousDrivers: prvDriver,
        nearbyDrivers: listNearDriver);
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "top_rated_drivers":
            List<dynamic>.from(topRatedDrivers.map((x) => x.toJson())),
        "previous_drivers": List<dynamic>.from(previousDrivers.map((x) => x)),
        "nearby_drivers":
            List<dynamic>.from(nearbyDrivers.map((x) => x.toJson())),
      };
}

class Driver {
  String? id;
  String? userId;
  String? fname;
  String? lname;
  String? mobileNumber;
  String? email;
  String? photo;
  String? rating;
  String? latitude;
  String? longitude;

  Driver({
    required this.id,
    required this.userId,
    required this.fname,
    required this.lname,
    required this.mobileNumber,
    required this.email,
    required this.photo,
    required this.rating,
    this.latitude,
    this.longitude,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        userId: json["user_id"],
        fname: json["fname"],
        lname: json["lname"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        photo: json["photo"],
        rating: json["rating"],
        latitude: json["latitude"],
        longitude: json["longitude "],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "fname": fname,
        "lname": lname,
        "mobile_number": mobileNumber,
        "email": email,
        "photo": photo,
        "rating": rating,
        "latitude": latitude,
        "longitude ": longitude,
      };
}
