import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/timer_provider.dart';

class TimerCircle extends StatelessWidget {
  const TimerCircle({super.key});

  @override
  Widget build(BuildContext context) {

    //final timerProvider = Provider.of(TimerProvider)(context);

    return LayoutBuilder(builder: (context, Constraints) {
      double diameter = Constraints.maxWidth * 0.7;
      double strokeWidth = diameter * 0.06;
      },)
  }
}
