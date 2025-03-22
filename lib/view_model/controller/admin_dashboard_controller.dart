import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/data/network/network_api_services.dart';
import 'package:mini_pro_app/models/user_data/user_data_model.dart';

class AdminDashboardController extends GetxController {
  final _api = NetworkApiServices();
  RxBool loading = false.obs;
  Rx<UserData?> userData = Rx<UserData?>(null);

  @override
  void onInit() {
    super.onInit();
    loadDetails();
  }

  void loadDetails() async {
    loading.value = true;
    debugPrint("Loading details in controller...");

    final result = await _api.getAllDataFromFirebase(path: "cycle_one");

    result.fold(
      (failure) {
        loading.value = false;
        debugPrint("Failed to load data: ${failure.toString()}");
        Get.snackbar(
          'Error',
          'Failed to load data: ${failure.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      },
      (success) {
        loading.value = false;
        userData.value = success; // Assigning fetched data directly
        debugPrint("Successfully loaded ${userData.value?.users.length ?? 0} users.");
      },
    );
  }
}