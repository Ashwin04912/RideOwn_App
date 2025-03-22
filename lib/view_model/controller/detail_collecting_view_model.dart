import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/repository/esp_repository/esp_local_repo.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/utils/utils.dart';

class DetailCollectingViewModel extends GetxController {
  final _api = EspLocalRepo();

  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final nameFocusNode = FocusNode().obs;
  final emailFocusNode = FocusNode().obs;
  final phoneFocusNode = FocusNode().obs;

  RxBool loading = false.obs;

  Future<void> saveUserDataToFirebase({
  required String otp,
  required String year,
}) async {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('cycle_one');

  try {
    // Set the availability flag separately
    await databaseRef.child("isAvailable").set(false);

    // Get the phone number
    String phoneNumber = phoneController.value.text;

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

    if (kDebugMode) {
      print("User data saved successfully for phone: $phoneNumber");
    }
  } on FirebaseException catch (e) {
    if (kDebugMode) {
      print("Firebase error: ${e.message}");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Unexpected error: $e");
    }
  }
}

  void getOtp() {
    Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "data": "getotp",
      "phone": phoneController.value.text,
    };

    _api.getOtpApi(data).then((value) {
      loading.value = false;
      Utils.snakBar('Success', "");
      Get.toNamed(RoutesName.otpScreen);
    }).onError((error, name) {
      //name is stackTrace
      loading.value = false;
      Utils.snakBar('Error', error.toString());
    });
  }



  void checkPassword({required String otp}) {
    // Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "otp": otp,
      
    };

    _api.checkPasswordApi(data).then((value) {
      loading.value = false;
      Utils.snakBar('Success', "Cycle has been Unlocked../n Happy Riding..");
      Get.toNamed(RoutesName.rideOnProgressScreen);
    }).onError((error, name) {
      //name is stackTrace
      loading.value = false;
      Utils.snakBar('Error', error.toString());
    });
  }


void lockCycle() {
    // Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "data": "lock_cycle",
      
    };

    _api.lockCycleApi(data).then((value) {
      loading.value = false;
      Utils.snakBar('Success', "Cycle has been locked...");
      Get.toNamed(RoutesName.rideOnProgressScreen);
    }).onError((error, name) {
      //name is stackTrace
      loading.value = false;
      Utils.snakBar('Error', error.toString());
    });
  }

  void returnCycle({required String otp}) {
    // Get.toNamed(RoutesName.loadingScreen);
    loading.value = true;
    Map<String, dynamic> data = {
      "data": "return_cycle",
      "otp":otp,
      
    };

    _api.returnCycleApi(data).then((value) {
      loading.value = false;
      Utils.snakBar('Success', "Cycle has been locked...");
      Get.toNamed(RoutesName.homeScreen);
    }).onError((error, name) {
      //name is stackTrace
      loading.value = false;
      Utils.snakBar('Error', error.toString());
    });
  }

}