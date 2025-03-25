import 'package:get/get.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenServices {
  void isRideOnProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isRideOnProgress = prefs.getBool('ride_status');
    if (isRideOnProgress == true) {
      Get.offNamed(
        RoutesName.rideOnProgressScreen,
        
      );
    } else {
      Get.offNamed(RoutesName.homeScreen);
    }
  }
}
