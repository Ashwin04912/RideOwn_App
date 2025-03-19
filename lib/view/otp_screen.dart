import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:mini_pro_app/res/colors/app_colors.dart';
import 'package:mini_pro_app/view_model/controller/detail_collecting_view_model.dart';

class OtpScreen extends StatefulWidget {
  final bool isReturnCycle;
  const OtpScreen({super.key, required this.isReturnCycle});

  @override
  // ignore: library_private_types_in_public_api
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final detailCollectionController = Get.put(DetailCollectingViewModel());
  String enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.black, // Dark app bar
        foregroundColor: Colors.white, // White text/icons
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter the password to unlock the cycle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Colors.white, // White borders
                enabledBorderColor: Colors.grey, // Grey border when not active
                focusedBorderColor: Colors.blue, // Blue when typing
                textStyle:
                    const TextStyle(color: Colors.white), // White OTP digits
                showFieldAsBox: true,
                fillColor: AppColors.blackColor, // Darker background for boxes
                filled: true,
                onSubmit: (String otp) {
                  enteredOtp = otp;
                },
              ),
              const SizedBox(height: 20),
              Obx(
                ()=> detailCollectionController.loading.value?const Center(child: CircularProgressIndicator(color:AppColors.redColor,),):
                ElevatedButton(
                  onPressed: () {
                    debugPrint("Entered OTP: $enteredOtp, ${widget.isReturnCycle}");
                    widget.isReturnCycle?detailCollectionController.returnCycle(otp: enteredOtp):
                    detailCollectionController.checkPassword(otp: enteredOtp);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue button
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
