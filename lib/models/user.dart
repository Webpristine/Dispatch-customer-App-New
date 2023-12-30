// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);
///"name": "Sanjay Sangal",
// "rating": "0.0",
// "email": "sugaminfo15@gmail.com",
// "mobile_number": "7217843304",
// "profile_photo": "https://webpristine.com/Dispatch-app/files/profile/profile-FC-0005.jpg",
// "total_ride": 0,
// "total_spend": "0.00"
import 'dart:convert';

UserModel addressFromJson(String str) => UserModel.fromJson(json.decode(str));

String addressToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? code;
  String? message;
  String? name;
  String? rating;
  String? email;
  String? mobileNumber;
  String? profilePhoto;
  int? totalRide;
  String? totalSpend;

  UserModel(
      {this.code,
      this.message,
      this.name,
      this.rating,
      this.email,
      this.mobileNumber,
      this.profilePhoto,
      this.totalRide,
      this.totalSpend});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    name = json['name'];
    rating = json['rating'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    profilePhoto = json['profile_photo'];
    totalRide = json['total_ride'];
    totalSpend = json['total_spend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['profile_photo'] = this.profilePhoto;
    data['total_ride'] = this.totalRide;
    data['total_spend'] = this.totalSpend;
    return data;
  }
}
