import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/res/colors/app_colors.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/view/otp_screen.dart';
import 'package:mini_pro_app/view_model/controller/detail_collecting_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this package for SVG support

class RideOnProgressScreen extends StatelessWidget {
  const RideOnProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detailController = Get.put(DetailCollectingViewModel());
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Darker background for better contrast
      appBar: AppBar(
        title: const Text(
          "Ride In Progress",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF1E1E1E),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => detailController.loading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.redColor,
                      strokeWidth: 3,
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Ride status card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Bike icon
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Color(0xFF3A3A3A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.pedal_bike,
                                color: AppColors.redColor,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Active Ride",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Your cycle is currently unlocked",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Instructions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          "You can Lock, Unlock, or Lock & Return the Cycle",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Action buttons
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Unlock Button
                            ElevatedButton.icon(
                              onPressed: () {
                                debugPrint("Cycle Unlocked");
                                Get.toNamed(RoutesName.otpScreen);
                              },
                              icon: const Icon(Icons.lock_open, color: Colors.white),
                              label: const Text(
                                "Unlock",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: Colors.green.withOpacity(0.5),
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
                              label: const Text(
                                "Lock",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: Colors.orange.withOpacity(0.5),
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
                              label: const Text(
                                "Lock & Return",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: AppColors.redColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}