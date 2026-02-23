import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';

class NormalTimer extends StatelessWidget {
  const NormalTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Column(
      children: [
        Text(
          timerProvider.timeString,
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
