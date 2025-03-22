import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_pro_app/res/assets/image_assets.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _wheelController;
  late AnimationController _bounceController;
  final List<String> _quotes = [
    "Ride as much or as little, as long or as short as you feel. But ride!",
    "Life is like riding a bicycle. To keep your balance, you must keep moving.",
    "When the spirits are low, when the day appears dark, just mount a bicycle and go out for a spin.",
    "Cyclers see considerably more of this beautiful world than any other class of citizens.",
    "You can't buy happiness, but you can buy a bicycle and that's pretty close.",
  ];
  late String _currentQuote;
  int _quoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _wheelController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _currentQuote = _quotes[_quoteIndex];
    
    // Change quote every 7 seconds
    Future.delayed(const Duration(seconds: 7), _changeQuote);
  }

  void _changeQuote() {
    if (!mounted) return;
    
    setState(() {
      _quoteIndex = (_quoteIndex + 1) % _quotes.length;
      _currentQuote = _quotes[_quoteIndex];
    });
    
    Future.delayed(const Duration(seconds: 7), _changeQuote);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

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
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
            child: Image.asset(
              ImageAssets.cycleHome,
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Top bar with admin login
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Get.toNamed(RoutesName.adminLoginScreen);
                          },
                          icon: const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white70,
                            size: 20,
                          ),
                          label: Text(
                            "Admin",
                            style: GoogleFonts.montserrat(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black38,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Discover Wayanad\non Two Wheels!",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        height: 1.2,
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
                  ),

                  // Cycling Animation
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Trail effect
                        Positioned(
                          bottom: 65,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.greenAccent.withOpacity(0),
                                  Colors.greenAccent.withOpacity(0.7),
                                  Colors.greenAccent.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Bouncing bicycle
                        AnimatedBuilder(
                          animation: _bounceController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                -5 * _bounceController.value,
                              ),
                              child: child,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Wheel 1
                              AnimatedBuilder(
                                animation: _wheelController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _wheelController.value * 2 * math.pi,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.greenAccent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.greenAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              // Bicycle frame
                              Container(
                                width: 80,
                                height: 2,
                                color: Colors.greenAccent,
                                margin: const EdgeInsets.only(bottom: 10),
                              ),
                              
                              // Wheel 2
                              AnimatedBuilder(
                                animation: _wheelController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _wheelController.value * 2 * math.pi,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.greenAccent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.greenAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quote section
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey<String>(_currentQuote),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.format_quote,
                            color: Colors.greenAccent,
                            size: 30,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _currentQuote,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // App description
                 

                  const SizedBox(height: 30),

                  // Ride request button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.detailCollectionScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        backgroundColor: Colors.greenAccent[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.pedal_bike,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Start Your Adventure",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Explore destinations button
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    child: TextButton.icon(
                      onPressed: () {
                        // Navigate to explore screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Explore feature coming soon!"),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.explore_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        "Explore Popular Destinations",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}