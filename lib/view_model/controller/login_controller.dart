import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/repository/login_repository/login_repo.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/utils/utils.dart';

class LoginController extends GetxController {
  final _api = LoginRepository();

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  RxBool loading = false.obs;

  void adminLogin() {
    loading.value = true;
    _api
        .loginApi(
            email: emailController.value.text,
            password: passwordController.value.text)
        .then((value) {
      value.fold((f) {
        debugPrint(value.toString());
        Utils.toastMessage(f.toString());
        loading.value = false;
      }, (s) {
        Get.offNamed(RoutesName.adminDashboard);
        Utils.toastMessage("Login Successfull");
        loading.value = false;
        //Navigaion
      });
    });
  }
}
