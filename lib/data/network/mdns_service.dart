import 'package:multicast_dns/multicast_dns.dart';
import 'package:flutter/foundation.dart';

class MdnsService {
  static String? _cachedIpAddress;

  static Future<String> getBaseUrl() async {
    // If we already resolved the IP, use the cached version
    if (_cachedIpAddress != null) {
      print("cashed Address $_cachedIpAddress");

      return "http://$_cachedIpAddress";
    }

    try {
      // Try to resolve using mDNS
      debugPrint("Attempting to resolve gecw-cycles.local via mDNS...");
      final ipAddress = await _resolveHostname('gecw-cycles');
      _cachedIpAddress = ipAddress;
      debugPrint("Resolved to IP: $ipAddress");
      return "http://$ipAddress";
    } catch (e) {
      // Log the error
      debugPrint("mDNS resolution failed: $e");

      // Fallback to the hostname if resolution fails
      return "http://gecw-cycles.local";
    }
  }

  static Future<String> _resolveHostname(String hostname) async {
    final MDnsClient client = MDnsClient();
    await client.start();

    try {
      debugPrint("Starting mDNS lookup for _http._tcp.local");

      // Look for HTTP services
      await for (final PtrResourceRecord ptr
          in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_http._tcp.local'),
      )) {
        debugPrint("Found service: ${ptr.domainName}");

        await for (final SrvResourceRecord srv
            in client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName),
        )) {
          debugPrint("Checking service: ${srv.name}");

          if (srv.name.contains(hostname)) {
            debugPrint("Found matching service: ${srv.target}");

            await for (final IPAddressResourceRecord ip
                in client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target),
            )) {
              final address = ip.address.address;
              debugPrint("Resolved to IP: $address");
              return address;
            }
          }
        }
      }

      // Alternative method: try direct name lookup
      debugPrint("Trying direct hostname lookup for $hostname.local");
      await for (final IPAddressResourceRecord ip
          in client.lookup<IPAddressResourceRecord>(
        ResourceRecordQuery.addressIPv4('$hostname.local'),
      )) {
        final address = ip.address.address;
        debugPrint("Resolved directly to IP: $address");
        return address;
      }

      throw Exception('Failed to resolve hostname via mDNS');
    } finally {
      client.stop();
    }
  }
}
