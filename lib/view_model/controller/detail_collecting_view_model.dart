// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mini_pro_app/repository/esp_repository/esp_local_repo.dart';
// import 'package:mini_pro_app/res/routes/routes.dart';
// import 'package:mini_pro_app/res/routes/routes_name.dart';
// import 'package:mini_pro_app/utils/utils.dart';

// class DetailCollectingViewModel extends GetxController {
//   final _api = EspLocalRepo();

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();


//   RxBool loading = false.obs;

//   Future<void> saveUserDataToFirebase({
//     required String otp,
//     required String year,
//   }) async {
//     debugPrint("hello to firebase, ${nameController.text}, ${emailController.text}, ${phoneController.text}, $otp, $year");

//     // Validate input fields before proceeding
//     if (nameController.text.isEmpty || 
//         emailController.text.isEmpty || 
//         phoneController.text.isEmpty) {
//       debugPrint("Error: One or more fields are empty.");
//       return;
//     }

//     final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('user_data');

//     try {
//       await databaseRef.child(phoneController.text).set({
//         "otp": otp,
//         "phone": phoneController.text,
//         "name": nameController.text,
//         "email": emailController.text,
//         "year": year,
//         "timestamp": DateTime.now().toIso8601String(),
//       });
//       if (kDebugMode) {
//         print("User data saved successfully.");
//       }
//     } on FirebaseException catch (e) {
//       if (kDebugMode) {
//         print("Firebase error: ${e.message}");
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Unexpected error: $e");
//       }
//     }
//   }

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     super.onClose();
//   }



//   Future<Map<String, dynamic>?> getAllUserData() async {
//     final DatabaseReference databaseRef =
//         FirebaseDatabase.instance.ref('user_data');

//     try {
//       DatabaseEvent event = await databaseRef.once();

//       if (event.snapshot.value != null) {
//         Map<String, dynamic> userData =
//             Map<String, dynamic>.from(event.snapshot.value as Map);

//         if (kDebugMode) {
//           print("Fetched user data successfully: $userData");
//         }

//         return userData;
//       } else {
//         if (kDebugMode) {
//           print("No user data found.");
//         }
//         return null;
//       }
//     } on FirebaseException catch (e) {
//       if (kDebugMode) {
//         print("Firebase error: ${e.message}");
//       }
//       return null;
//     } catch (e) {
//       if (kDebugMode) {
//         print("Unexpected error: $e");
//       }
//       return null;
//     }
//   }

//   void getOtp() {
//     loading.value = true;
//     var data = {
//       "data": "getotp",
//       "phone": phoneController.value.text,
//     };
//     Get.toNamed(RoutesName.loadingScreen);
//     _api.getOtpApi(data).then((value) {
//       loading.value = false;
//       Utils.snakBar('Success', "");
//     }).onError((error, name) {
//       //name is stackTrace
//       loading.value = false;
//       Utils.snakBar('Error', error.toString());
//     });
//   }

//   void checkPassword({required String otp}) {
//     loading.value = true;
//     var data = {
//       "otp": otp,
//     };

//     _api.checkPasswordApi(data).then((value) {
//       loading.value = false;
//       Utils.snakBar('Success', "");
//     }).onError((error, name) {
//       //name is stackTrace
//       loading.value = false;
//       Utils.snakBar('Error', error.toString());
//     });
//   }

//   void lockCycle() {
//     loading.value = true;
//     var data = {
//       "data": "lock_cycle",
//     };

//     _api.lockCycleApi(data).then((value) {
//       loading.value = false;
//       Utils.snakBar('Success', "");
//     }).onError((error, name) {
//       //name is stackTrace
//       loading.value = false;
//       Utils.snakBar('Error', error.toString());
//     });
//   }

//   void returnCycle({required String otp}) {
//     loading.value = true;
//     var data = {"data": "return_cycle", "otp": otp};

//     _api.returnCycleApi(data).then((value) {
//       loading.value = false;
//       Utils.snakBar('Success', "");
//     }).onError((error, name) {
//       //name is stackTrace
//       loading.value = false;
//       Utils.snakBar('Error', error.toString());
//     });
//   }
// }




import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/repository/esp_repository/esp_local_repo.dart';

import 'package:mini_pro_app/res/routes/routes.dart';
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