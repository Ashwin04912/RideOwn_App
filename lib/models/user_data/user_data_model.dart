import 'dart:convert';
UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));
String userDataToJson(UserData data) => json.encode(data.toJson());
class UserData {
    bool isAvailable;
    Map<dynamic, User> users;
    UserData({
        required this.isAvailable,
        required this.users,
    });
    factory UserData.fromJson(Map<dynamic, dynamic> json) => UserData(
        isAvailable: json["isAvailable"],
        users: Map.from(json["users"]).map((k, v) => MapEntry<dynamic, User>(k, User.fromJson(v))),
    ); 
    Map<dynamic, dynamic> toJson() => {
        "isAvailable": isAvailable,
        "users": Map.from(users).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}
class User {
    String phone;
    String year;
    String name;
    String otp;
    String email;
    String status;
    DateTime timestamp;
    User({
        required this.phone,
        required this.year,
        required this.name,
        required this.otp,
        required this.email,
        required this.status,
        required this.timestamp,
    });
    factory User.fromJson(Map<dynamic, dynamic> json) => User(
        phone: json["phone"],
        year: json["year"],
        name: json["name"],
        otp: json["otp"],
        email: json["email"],
        status: json["status"],
        timestamp: DateTime.parse(json["timestamp"]),
    );
    Map<dynamic, dynamic> toJson() => {
        "phone": phone,
        "year": year,
        "name": name,
        "otp": otp, 
        "email": email,
        "status": status,
        "timestamp": timestamp.toIso8601String(),
    };
}