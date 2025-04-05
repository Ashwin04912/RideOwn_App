import 'package:flutter/foundation.dart';
import 'package:mini_pro_app/data/network/network_api_services.dart';

class HomeRepo {
  final _apiServices = NetworkApiServices();
  Future<bool> checkCycleAvailability() async {
    debugPrint("in check availability");
    return await _apiServices.checkCycleAvailability();
  }
}
