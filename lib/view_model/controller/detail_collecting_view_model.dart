import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/repository/esp_repository/esp_local_repo.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailCollectingViewModel extends GetxController {
  final _api = EspLocalRepo();

  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final nameFocusNode = FocusNode().obs;
  final emailFocusNode = FocusNode().obs;
  final phoneFocusNode = FocusNode().obs;

  RxString globalPh = "".obs;

  RxBool loading = false.obs;

  Future<void> saveUserDataToFirebase({
    required String otp,
    required String year,
  }) async {
    loading.value = true;
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref('cycle_one');

    try {
      // Set the availability flag separately
      await databaseRef.child("isAvailable").set(false);

      // Get the phone number
      String phoneNumber = phoneController.value.text;
final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_phone", phoneNumber.toString());
      // Save user data using the phone number as the key
      await databaseRef.child("users").child(phoneNumber.toString()).set({
        "otp": otp,
        "phone": phoneNumber,
        "name": nameController.value.text,
        "email": emailController.value.text,
        "year": year,
        "timestamp": DateTime.now().toIso8601String(),
        "status": "On_Ride"
      });

      globalPh.value = phoneNumber;
      

      if (kDebugMode) {
        print("User data saved successfully for phone: $phoneNumber");
      }
    } on FirebaseException catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print("Firebase error: ${e.message}");
      }
    } catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
    }
  }

  void getOtp() async {
    Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "data": "getotp",
      "phone": phoneController.value.text,
    };

    await _api.getOtpApi(data).then((value) {
      value.fold((f) {
        Get.back();
        loading.value = false;
        Utils.snakBar('Error', f.toString());
      }, (s) {
        loading.value = false;
        Utils.snakBar('Success', "");
        Get.offNamed(RoutesName.otpScreen);
      });
    });
  }

  void checkPassword({required String otp}) async {
    // Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "otp": otp,
    };

    await _api.checkPasswordApi(data).then((value) {
      value.fold((f) {
        loading.value = false;
        Utils.snakBar('Error', f.toString());
      }, (s) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        loading.value = false;
        Utils.snakBar('Success', "Cycle has been Unlocked../n Happy Riding..");
        prefs.setBool("ride_status", true);
        Get.offAllNamed(RoutesName.rideOnProgressScreen);
      });
    });
  }

  void lockCycle() {
    // Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "data": "lock_cycle",
    };

    _api.lockCycleApi(data).then((value) {
      value.fold((f) {
        Utils.snakBar("Error", f.toString());
      }, (s) {
        loading.value = false;
        Utils.snakBar('Success', "Cycle has been locked...");
        // Get.toNamed(RoutesName.rideOnProgressScreen);
      });
    });
  }

  void returnCycle({required String otp}) async {
    // Get.toNamed(RoutesName.loadingScreen);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //  prefs.setBool("ride_status", false);
    loading.value = true;
    Map<String, dynamic> data = {
      "data": "return_cycle",
      "otp": otp,
    };
   
    final String number =prefs.getString("saved_phone")??"";
     debugPrint("hello nubmer  $number");

    _api
        .returnCycleApi(data: data, phoneNumber: number)
        .then((value) {
      value.fold((f) {
        loading.value = false;
        Utils.snakBar('Error', f.toString());
      }, (s) {
        prefs.setBool("ride_status", false);
        loading.value = false;
        Utils.snakBar('Success', "Cycle has been locked...");
        Get.offNamed(RoutesName.homeScreen);
      });
    });
  }
}
