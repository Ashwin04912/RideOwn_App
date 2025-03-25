import 'package:multicast_dns/multicast_dns.dart';

Future<String?> resolveMDNS() async {
  final MDnsClient client = MDnsClient();
  await client.start();

  try {
    // Query for the ESP32 hostname
    const String serviceName = 'gecw-cycles.local';
    final List<IPAddressResourceRecord> response =
        await client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(serviceName)).toList();

    if (response.isNotEmpty) {
      return response.first.address.address; // Return resolved IP
    }
  } finally {
    client.stop();
  }
  return null;
}