import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:multicast_dns/multicast_dns.dart';

class AppUrls {
  static String? _resolvedIp;
  static const _fallbackIp = '192.168.45.111'; // Optional: keep your last known working IP
  static const _multicastChannel = MethodChannel('multicast_lock');

  /// Call this in `main()` before anything else if targeting Android
  static Future<void> enableMulticastLock() async {
    if (Platform.isAndroid) {
      try {
        await _multicastChannel.invokeMethod('acquire');
        debugPrint('✅ Multicast lock acquired');
      } on PlatformException catch (e) {
        debugPrint('❌ Failed to acquire multicast lock: $e');
      }
    }
  }

  static Future<void> resolveEspIp() async {
    final MDnsClient client = MDnsClient();
    await client.start();

    try {
      const String serviceName = 'gecw-cycles.local';
      final response = await client
          .lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(serviceName))
          .toList();
      
      debugPrint("🔍 mDNS response: $response");

      if (response.isNotEmpty) {
        _resolvedIp = response.first.address.address;
        debugPrint("✅ ESP resolved IP: $_resolvedIp");
      } else {
        debugPrint("⚠️ No IP resolved. Falling back to $_fallbackIp");
      }
    } catch (e) {
      debugPrint('❌ Error resolving ESP IP: $e');
    } finally {
      client.stop();
    }
  }

  static String get baseUrl => "http://${_resolvedIp ?? _fallbackIp}";
  static String get espGetOtpUrl => "$baseUrl/get-otp";
  static String get espCheckPassUrl => "$baseUrl/check-password";
  static String get espLockCycleUrl => "$baseUrl/lock_cycle";
  static String get espReturnCycle => "$baseUrl/return_cycle";
}
