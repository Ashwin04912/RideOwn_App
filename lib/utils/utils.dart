import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/res/colors/app_colors.dart';

//create the repeating functions here...

class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: AppColors.blackColor);
  }

  static snakBar(String title, String message) {
    Get.snackbar(title, message, colorText: AppColors.whiteColor);
  }

  static Widget loadingAnimation() {
   return const SpinKitSpinningLines(
      color: Colors.white,
      size: 30.0,
    );
  }
}
