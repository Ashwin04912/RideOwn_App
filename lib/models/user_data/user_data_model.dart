// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  Map<String, UserDatum> userData;

  UserData({
    required this.userData,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userData: Map.from(json["user_data"]).map(
            (k, v) => MapEntry<String, UserDatum>(k, UserDatum.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "user_data": Map.from(userData)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class UserDatum {
  String email;
  String name;
  dynamic otp;
  String phone;
  DateTime timestamp;
  Year year;

  UserDatum({
    required this.email,
    required this.name,
    required this.otp,
    required this.phone,
    required this.timestamp,
    required this.year,
  });

  factory UserDatum.fromJson(Map<String, dynamic> json) => UserDatum(
        email: json["email"],
        name: json["name"],
        otp: json["otp"],
        phone: json["phone"],
        timestamp: DateTime.parse(json["timestamp"]),
        year: yearValues.map[json["year"]]!,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "otp": otp,
        "phone": phone,
        "timestamp": timestamp.toIso8601String(),
        "year": yearValues.reverse[year],
      };
}

enum Year {
  THE_1_ST_YEAR,
  THE_2_ND_YEAR,
  THE_3_RD_YEAR,
  THE_4_TH_YEAR,
}

final yearValues = EnumValues({
  "1st Year": Year.THE_1_ST_YEAR,
  "2nd Year": Year.THE_2_ND_YEAR,
  "3rd Year": Year.THE_3_RD_YEAR,
  "4th Year": Year.THE_4_TH_YEAR
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
