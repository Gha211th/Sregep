import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/ui/dashboard/widgets/widget_navbar.dart';
import 'dart:async';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0077B6),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sregep",
                  style: GoogleFonts.outfit(
                    color: Color(0xFFFFFFFF),
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "[ Focus - Study - Achieve ]",
                  style: GoogleFonts.outfit(
                    color: Color(0xFFFFFFFF),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Loading....",
                  style: GoogleFonts.outfit(
                    color: Color(0xFFFFFFFF),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
