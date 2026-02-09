import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/timer_provider.dart';

class TimerCircle extends StatelessWidget {
  const TimerCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final screenWidth = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, Constraints) {
        double diameter = Constraints.maxWidth * 0.6;
        double strokeWidth = diameter * 0.05;

        return Column(
          children: [
            SizedBox(height: screenWidth.height * 0.05),
            Container(
              width: diameter + 5,
              height: diameter + 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: diameter,
                    height: diameter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: strokeWidth,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: diameter,
                    height: diameter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        value: timerProvider.progress,
                        strokeWidth: strokeWidth,
                        backgroundColor: Colors.transparent,
                        color: const Color(0xFF34A0D3),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  Text(
                    timerProvider.timeString,
                    style: GoogleFonts.outfit(
                      fontSize: diameter * 0.22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF34A0D3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
