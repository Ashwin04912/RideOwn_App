import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_pro_app/repository/esp_repository/esp_local_repo.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/view/loading_screen.dart';
import 'package:mini_pro_app/view_model/controller/detail_collecting_view_model.dart';
import 'package:slider_button/slider_button.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailCollectionScreen extends StatefulWidget {
  const DetailCollectionScreen({super.key});

  @override
  _DetailCollectionScreenState createState() => _DetailCollectionScreenState();
}

class _DetailCollectionScreenState extends State<DetailCollectionScreen> {
  final detailCollectionController = Get.put(DetailCollectingViewModel());

  final _formKey = GlobalKey<FormState>();
  final _databaseRef =
      FirebaseDatabase.instance.ref("user_data"); // Firebase DB reference

  String? _selectedClass;
  final List<String> _classes = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year'
  ];

  bool _formSubmitted = false;

  bool _isFormValid() {
    return _formKey.currentState?.validate() ?? false && _selectedClass != null;
  }

  void _submitForm() async {
    setState(() {
      _formSubmitted = true;
    });

    if (_isFormValid()) {
      int otp = generateOtp();
      debugPrint("Generated OTP: $otp");

    detailCollectionController.saveUserDataToFirebase(otp: otp.toString(),year: _selectedClass!);

      // Show OTP in a popup
      _showOtpPopup(otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill all fields correctly",
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }



  void _showOtpPopup(int otp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Your Password",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[400],
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your password for the entire ride is:",
                style:
                    GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                otp.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[300],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Note : This password will not be visible later so note this now...",
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
              debugPrint("hello screen");
                detailCollectionController.getOtp();
              },
              child: Text(
                "OK",
                style: GoogleFonts.montserrat(color: Colors.teal[400]),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Center(
          child: Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your details",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      "Full Name",
                      detailCollectionController.nameFocusNode.value,
                      detailCollectionController.nameController.value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      "Email",
                      detailCollectionController.emailFocusNode.value,
                      detailCollectionController.emailController.value,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      "Phone Number",
                      detailCollectionController.phoneFocusNode.value,
                      detailCollectionController.phoneController.value,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Phone number is required";
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return "Enter a valid 10-digit number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Year?",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    _buildDropdown(),
                    if (_formSubmitted && _selectedClass == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Please select a class",
                          style: GoogleFonts.montserrat(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 30),
                    detailCollectionController.loading.value
                        ? Center(
                            child: SpinKitDoubleBounce(
                              // This creates a pulsing leaf effect
                              color: Colors.greenAccent.shade400,
                              // waveColor: Colors.lightGreen,
                              size: 100.0,
                            ),
                          )
                        : Center(
                            child: SliderButton(
                              action: () async {
                                setState(() {});
                                _submitForm();
                                return _isFormValid();
                              },
                              alignLabel: Alignment.center,
                              buttonColor: Colors.white,
                              backgroundColor: _isFormValid()
                                  ? Colors.teal[700]!
                                  : Colors.grey,
                              shimmer: true,
                              label: Text(
                                "Slide to Submit",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.teal[700]!,
                              ),
                              height: 60,
                              width: double.infinity,
                            ),
                          ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    FocusNode focus,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      // focusNode: focus,
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(color: Colors.teal[300]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[400]!),
        ),
        filled: true,
        fillColor: Colors.grey[850],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedClass,
      onChanged: (newValue) => setState(() => _selectedClass = newValue),
      items: _classes
          .map((year) => DropdownMenuItem(
                value: year,
                child: Text(
                  year,
                  style:
                      GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
                ),
              ))
          .toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[850], // Light grey background
        labelText: "Select Year",
        labelStyle: GoogleFonts.montserrat(color: Colors.green[800]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded border
          borderSide: BorderSide(color: Colors.green[600]!), // Green border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green[800]!, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dropdownColor: Colors.grey[850], // Light grey dropdown background
    );
  }
}

int generateOtp() {
  return 1000 + Random().nextInt(9000);
}
