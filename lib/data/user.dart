//https://app.quicktype.io/

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String nickName;
  String refreshToken;
  String token;
  String tokenHead;
  String userName;

  User({
    required this.id,
    required this.nickName,
    required this.refreshToken,
    required this.token,
    required this.tokenHead,
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nickName: json["nickName"],
        refreshToken: json["refreshToken"],
        token: json["token"],
        tokenHead: json["tokenHead"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickName": nickName,
        "refreshToken": refreshToken,
        "token": token,
        "tokenHead": tokenHead,
        "userName": userName,
      };
}
