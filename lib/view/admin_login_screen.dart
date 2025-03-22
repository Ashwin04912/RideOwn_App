import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_pro_app/res/assets/image_assets.dart';
import 'package:mini_pro_app/view_model/controller/login_controller.dart';

// ignore: must_be_immutable
class AdminLoginScreen extends StatelessWidget {
  AdminLoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // Background with blur overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
                child: Image.asset(
                  ImageAssets.cycleHome,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // App bar with back button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Admin icon and header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[700]!.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 70,
                        color: Colors.greenAccent,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Admin Login",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Access the cycle rental management dashboard",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Login form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Username field
                          TextFormField(
                            controller: loginController.emailController.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              prefixIcon: const Icon(Icons.person_outline,
                                  color: Colors.greenAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.greenAccent[400]!, width: 2),
                              ),
                              errorStyle:
                                  const TextStyle(color: Colors.redAccent),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Password field
                          TextFormField(
                            controller:
                                loginController.passwordController.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Colors.greenAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.greenAccent[400]!, width: 2),
                              ),
                              errorStyle:
                                  const TextStyle(color: Colors.redAccent),
                            ),
                          ),

                          const SizedBox(height: 15),

                          

                          const SizedBox(height: 30),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Obx(
                              () => loginController.loading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          loginController.adminLogin();
                                          
                                        }
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.greenAccent[700],
                                        disabledBackgroundColor: Colors
                                            .greenAccent[700]!
                                            .withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Contact support text
                    Text(
                      "Need help? Contact support",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),

                    // Version info
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "v1.0.0",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
