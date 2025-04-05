import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class AppUrls {
  static String? _resolvedIp;
  static const _fallbackIp = '192.168.45.111'; // Optional: keep your last known working IP
  static const _firebasePath = 'cycle_one/ip_address'; // Path to the IP address in Firebase

  /// Fetch the ESP IP address from Firebase
  static Future<void> resolveEspIpFromFirebase() async {
    try {
      final DatabaseReference databaseRef = FirebaseDatabase.instance.ref(_firebasePath);
      final DataSnapshot snapshot = await databaseRef.get();

      if (snapshot.exists) {
        _resolvedIp = snapshot.value as String;
        debugPrint("✅ ESP IP resolved from Firebase: $_resolvedIp");
      } else {
        debugPrint("⚠️ No IP found in Firebase. Falling back to $_fallbackIp");
      }
    } catch (e) {
      debugPrint('❌ Error fetching ESP IP from Firebase: $e');
    }
  }

  static String get baseUrl => "http://${_resolvedIp ?? _fallbackIp}";
  static String get espGetOtpUrl => "$baseUrl/get-otp";
  static String get espCheckPassUrl => "$baseUrl/check-password";
  static String get espLockCycleUrl => "$baseUrl/lock_cycle";
  static String get espReturnCycle => "$baseUrl/return_cycle";
}