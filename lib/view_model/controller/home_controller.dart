import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/repository/home_repository/home_repo.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/utils/utils.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  final _api = HomeRepo();
  final databaseRef = FirebaseDatabase.instance.ref();

  Future<void> checkCycleAvailability() async {
    loading.value = true;

    final resp = await _api.checkCycleAvailability();
    loading.value = false;
    if(resp == true){
      Get.toNamed(RoutesName.detailCollectionScreen);
    }
    else{
      Utils.toastMessage("Cycle is not available");
    }
  }
}
