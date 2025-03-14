import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/repository/detail_collecting_repo/detail_collecting_repo.dart';
import 'package:mini_pro_app/res/routes/routes.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/utils/utils.dart';

class DetailCollectingViewModel extends GetxController {
  final _api = DetailCollectingRepo();

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
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('user_data');

    try {
      await databaseRef.child(phoneController.value.text).set({
        "otp": otp,
        "phone": phoneController.value.text,
        "name": nameController.value.text,
        "email": emailController.value.text,
        "year": year,
        "timestamp": DateTime.now().toIso8601String(),
      });
      if (kDebugMode) {
        print("User data saved successfully.");
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
    loading.value = true;
    var data = {
      "data": "getotp",
      "phone": "phoneController.value.text",
    };

    _api.getOtpApi(data).then((value) {
      loading.value = false;
      Utils.snakBar('Success', "");
      Get.toNamed(RoutesName.loadingScreen);
    }).onError((error, name) {
      //name is stackTrace
      loading.value = false;
      Utils.snakBar('Error', error.toString());
    });
  }
}
