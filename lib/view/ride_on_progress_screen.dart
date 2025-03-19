import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/res/colors/app_colors.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/view/otp_screen.dart';
import 'package:mini_pro_app/view_model/controller/detail_collecting_view_model.dart';

class RideOnProgressScreen extends StatelessWidget {
 
  const RideOnProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final detailController = Get.put(DetailCollectingViewModel());
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme Background
      appBar: AppBar(
        title: const Text("Ride On Progress"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            ()=>detailController.loading.value?const Center(child: CircularProgressIndicator(color: AppColors.redColor,),): Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You can Lock, Unlock, or Lock & Return the Cycle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
            
                // Unlock Button
                ElevatedButton.icon(
                  onPressed: () {
                    debugPrint("Cycle Unlocked");
                    Get.toNamed(RoutesName.otpScreen);
                  },
                  icon: const Icon(Icons.lock_open, color: Colors.white),
                  label: const Text("Unlock"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 15),
            
                // Lock Button
                
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint("Cycle Locked");
                      detailController.lockCycle();
                    },
                    icon: const Icon(Icons.lock, color: Colors.white),
                    label: const Text("Lock"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                
                const SizedBox(height: 15),
            
                // Lock & Return Button
               
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint("Cycle Locked & Returned");
                      Get.to(() => const OtpScreen(isReturnCycle: true));
            
                    },
                    icon: const Icon(Icons.directions_bike, color: Colors.white),
                    label: const Text("Lock & Return"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}