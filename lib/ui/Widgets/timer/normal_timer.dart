import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';

class NormalTimer extends StatelessWidget {
  const NormalTimer({super.key});
  double getFontSizeForTimer(double width) {
    if (width > 1600) return 150;
    if (width > 1200) return 120;
    if (width > 800) return 120;
    if (width > 480) return 100;
    return 80;
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          timerProvider.timeString,
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: getFontSizeForTimer(screenSize.width),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
