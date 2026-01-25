import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/subject_picker.dart';
import 'widgets/timer_circle.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 75),
              Text(
                "Hello Student",
                style: GoogleFonts.outfit(
                  color: Color(0xFF34A0D3),
                  fontWeight: FontWeight.w500,
                  fontSize: 40,
                  height: 1,
                ),
              ),
              Text(
                "Ready to be productive?",
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Color(0xffB3B3B3),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 30),
              SubjectPicker(),
              Expanded(child: Center(child: const TimerCircle())),
              _buildControlButtons(timerProvider),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons(TimerProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: provider.isRunning ? null : () => provider.startTimer(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34A0D3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          child: Text("Start", style: GoogleFonts.outfit(fontSize: 14)),
        ),
        OutlinedButton(
          onPressed: !provider.isRunning ? null : () => provider.stopTimer(),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF34A0D3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          child: Text("Stop", style: GoogleFonts.outfit(fontSize: 14)),
        ),
      ],
    );
  }
}
