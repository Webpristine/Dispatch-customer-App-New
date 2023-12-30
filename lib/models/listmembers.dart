// To parse this JSON data, do
//
//     final listMembers = listMembersFromJson(jsonString);

import 'dart:convert';

ListMembers listMembersFromJson(String str) =>
    ListMembers.fromJson(json.decode(str));

String listMembersToJson(ListMembers data) => json.encode(data.toJson());

class ListMembers {
  int code;
  String message;
  List<Member> members;

  ListMembers({
    required this.code,
    required this.message,
    required this.members,
  });

  factory ListMembers.fromJson(Map<String, dynamic> json) => ListMembers(
        code: json["code"],
        message: json["message"],
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}

class Member {
  String id;
  String fname;
  String lname;
  String mobileNumber;
  String email;
  String address;

  Member({
    required this.id,
    required this.fname,
    required this.lname,
    required this.mobileNumber,
    required this.email,
    required this.address,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        fname: json["fname"],
        lname: json["lname"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "lname": lname,
        "mobile_number": mobileNumber,
        "email": email,
        "address": address,
      };
}
