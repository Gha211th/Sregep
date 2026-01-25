import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/timer_provider.dart';

class TimerCircle extends StatelessWidget {
  const TimerCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: timerProvider.progress,
            strokeWidth: 12,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF34A0D3),
            strokeCap: StrokeCap.round,
          ),
        ),
        Text(
          timerProvider.timeString,
          style: GoogleFonts.outfit(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF34A0D3),
          ),
        ),
      ],
    );
  }
}
