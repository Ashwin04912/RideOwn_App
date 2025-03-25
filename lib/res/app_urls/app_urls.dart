import 'package:multicast_dns/multicast_dns.dart';

class AppUrls {
  static String? _resolvedIp;
  
  static Future<void> resolveEspIp() async {
    final MDnsClient client = MDnsClient();
    await client.start();

    try {
      final String serviceName = 'gecw-cycles.local';
      final List<IPAddressResourceRecord> response =
          await client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(serviceName)).toList();

      if (response.isNotEmpty) {
        _resolvedIp = response.first.address.address;
      }
    } finally {
      client.stop();
    }
  }

  static String get baseUrl {
    return _resolvedIp != null ? "http://$_resolvedIp" : "http://192.168.45.111"; // Fallback to hardcoded IP
  }

  static String get espGetOtpUrl => "$baseUrl/get-otp";
  static String get espCheckPassUrl => "$baseUrl/check-password";
  static String get espLockCycleUrl => "$baseUrl/lock_cycle";
  static String get espReturnCycle => "$baseUrl/return_cycle";
}