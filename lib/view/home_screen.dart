import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_pro_app/res/assets/image_assets.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Dark Overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
            child: Image.asset(
              ImageAssets.cycleHome, // Ensure the image exists in assets
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30), // Added space for a balanced layout

                // Header Text
                Column(
                  children: [
                    Text(
                      "Discover Wayanad\non Two Wheels!",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            blurRadius: 15.0,
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Breathe in the misty air, ride through lush green valleys, and explore the hidden gems of Wayanad—on a cycle! Join the eco-friendly adventure today!",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1.1,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(),
                SpinKitDoubleBounce(
                  // This creates a pulsing leaf effect
                  color: Colors.greenAccent.shade400,
                  // waveColor: Colors.lightGreen,
                  size: 100.0,
                ),

                const Spacer(), // Push button downward for better spacing

                // "Request for a Ride" Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: const Color.fromARGB(0, 197, 14,
                        14), // Make the button background transparent
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    // elevation: 10,
                    shadowColor: Colors.greenAccent[700]!,
                    side: BorderSide(
                        color: Colors.greenAccent[700]!,
                        width: 2), // Border color
                    // Adding gradient background
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  onPressed: () {
                    // Action for requesting ride
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ride request initiated!")),
                     
                    );

                    Get.toNamed(RoutesName.detailCollectionScreen);
                    //  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const StudentDetailsScreen()));
                  },
                  child: Ink(
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [Colors.greenAccent[700]!, Colors.green[600]!],
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //   ),
                    //   borderRadius: BorderRadius.circular(30),
                    // ),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 250, minHeight: 50),
                      alignment: Alignment.center,
                      child: Text(
                        "Request a Ride",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40), // Space before footer text

                // Footer Text
                Text(
                  "Ride More, Explore More! 🚴‍♂️🌿",
                  style: GoogleFonts.pacifico(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20), // Extra bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}
