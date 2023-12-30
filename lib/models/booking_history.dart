import 'dart:convert';

class BookingHistory {
  int? code;
  String? message;
  List<Booking>? bookings;

  BookingHistory({this.code, this.message, this.bookings});

  BookingHistory.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['bookings'] != null) {
      bookings = <Booking>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Booking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  String bookingId;
  String bookingDate;
  String amount;
  String status;
  String driverName;
  String driverEmail;
  String driverMobileNumber;
  String driverProfilePhoto;
  String driverRating;
  PickupLocation pickupLocation;
  List<PickupLocation> dropLocation;

  Booking({
    required this.bookingId,
    required this.bookingDate,
    required this.amount,
    required this.status,
    required this.driverName,
    required this.driverEmail,
    required this.driverMobileNumber,
    required this.driverProfilePhoto,
    required this.driverRating,
    required this.pickupLocation,
    required this.dropLocation,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json["booking_id"],
        bookingDate: json["booking_date"],
        amount: json["amount"],
        status: json["status"],
        driverName: json["driver_name"],
        driverEmail: json["driver_email"],
        driverMobileNumber: json["driver_mobile_number"],
        driverProfilePhoto: json["driver_profile_photo"],
        driverRating: json["driver_rating"],
        pickupLocation: PickupLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PickupLocation>.from(
            json["drop_location"].map((x) => PickupLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "booking_date": bookingDate,
        "amount": amount,
        "status": status,
        "driver_name": driverName,
        "driver_email": driverEmail,
        "driver_mobile_number": driverMobileNumber,
        "driver_profile_photo": driverProfilePhoto,
        "driver_rating": driverRating,
        "pickup_location": pickupLocation.toJson(),
        "drop_location":
            List<dynamic>.from(dropLocation.map((x) => x.toJson())),
      };
}

class Bookings {
  String? bookingId;
  String? bookingDate;
  String? amount;
  String? waitingCharges;
  String? status;

  String? driverName;
  String? driverEmail;
  String? driverMobileNumber;
  String? driverProfilePhoto;
  String? driverRating;
  PickupLocation? pickupLocation;
  List<PickupLocation>? dropLocation;
  String? distance;
  String? timing;
  String? driverLat;
  String? driverLong;

  Bookings({
    this.bookingId,
    this.bookingDate,
    this.amount,
    this.status,
    this.driverName,
    this.driverEmail,
    this.driverMobileNumber,
    this.driverProfilePhoto,
    this.driverRating,
    this.pickupLocation,
    this.dropLocation,
    this.distance,
    this.timing,
    this.driverLat,
    this.driverLong,
  });

  Bookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingDate = json['booking_date'];
    amount = json['amount'];
    driverRating = json["driver_rating"];

    amount = json['waiting_charges'];
    status = json['status'];
    driverName = json['driver_name'];
    driverEmail = json['driver_email'];
    driverMobileNumber = json['driver_mobile_number'] ?? json['driver_mobile'];
    driverProfilePhoto = json['driver_profile_photo'] ?? json['profile_photo'];
    distance = json['distance'];
    timing = json['timing'];

    pickupLocation = json['pickup_location'] != null
        ? new PickupLocation.fromJson(json['pickup_location'])
        : null;
    if (json['drop_location'] != null) {
      dropLocation = <PickupLocation>[];
      if (pickupLocation != null) {
        dropLocation!.add(pickupLocation!);
      }
      json['drop_location'].forEach((v) {
        dropLocation!.add(new PickupLocation.fromJson(v));
      });
      driverLat = json['driver_lat'];
      driverLong = json['driver_long'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_date'] = this.bookingDate;
    data['amount'] = this.amount;
    data['status'] = this.status;
    if (this.pickupLocation != null) {
      data['pickup_location'] = this.pickupLocation!.toJson();
    }
    if (this.dropLocation != null) {
      data['drop_location'] =
          this.dropLocation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickupLocation {
  String? lat;
  String? long;
  String? address;

  PickupLocation({this.lat, this.long, this.address});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    return data;
  }
}

// To parse this JSON data, do
//
//     final rideStatus = rideStatusFromJson(jsonString);

RideStatus rideStatusFromJson(String str) =>
    RideStatus.fromJson(json.decode(str));

String rideStatusToJson(RideStatus data) => json.encode(data.toJson());

class RideStatus {
  int code;
  String message;
  String bookingId;
  String bookingDate;
  String amount;
  String status;
  String driverId;
  String driverName;
  String driverEmail;
  String driverMobile;
  String driverRating;
  String driverLat;
  String driverLong;
  String profilePhoto;
  PickupLocation pickupLocation;
  List<PickupLocation> dropLocation;
  String distance;
  String timing;

  RideStatus({
    required this.code,
    required this.message,
    required this.bookingId,
    required this.bookingDate,
    required this.amount,
    required this.status,
    required this.driverId,
    required this.driverName,
    required this.driverEmail,
    required this.driverMobile,
    required this.driverRating,
    required this.driverLat,
    required this.driverLong,
    required this.profilePhoto,
    required this.pickupLocation,
    required this.dropLocation,
    required this.distance,
    required this.timing,
  });

  factory RideStatus.fromJson(Map<String, dynamic> json) => RideStatus(
        code: json["code"],
        message: json["message"],
        bookingId: json["booking_id"],
        bookingDate: json["booking_date"],
        amount: json["amount"],
        status: json["status"],
        driverId: json["driver_id"],
        driverName: json["driver_name"],
        driverEmail: json["driver_email"],
        driverMobile: json["driver_mobile"],
        driverRating: json["driver_rating"],
        driverLat: json["driver_lat"],
        driverLong: json["driver_long"],
        profilePhoto: json["profile_photo"],
        pickupLocation: PickupLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PickupLocation>.from(
            json["drop_location"].map((x) => PickupLocation.fromJson(x))),
        distance: json["distance"],
        timing: json["timing"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "booking_id": bookingId,
        "booking_date": bookingDate,
        "amount": amount,
        "status": status,
        "driver_id": driverId,
        "driver_name": driverName,
        "driver_email": driverEmail,
        "driver_mobile": driverMobile,
        "driver_rating": driverRating,
        "driver_lat": driverLat,
        "driver_long": driverLong,
        "profile_photo": profilePhoto,
        "pickup_location": pickupLocation.toJson(),
        "drop_location":
            List<dynamic>.from(dropLocation.map((x) => x.toJson())),
        "distance": distance,
        "timing": timing,
      };
}

class PLocation {
  String lat;
  String long;
  String address;

  PLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory PLocation.fromJson(Map<String, dynamic> json) => PLocation(
        lat: json["lat"],
        long: json["long"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
        "address": address,
      };
}
