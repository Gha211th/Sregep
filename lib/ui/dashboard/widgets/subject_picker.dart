import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import '../../../providers/timer_provider.dart';

class SubjectPicker extends StatelessWidget {
  const SubjectPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final subjects = ['MTK', 'IPA', 'IPS', 'Bhs.Indonesia', 'Bhs.Inggris'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text("Select The Mapel To Focus", style: GoogleFonts.outfit(fontSize: 13, color: AppColors.accent),),
          ],
        )
      ],
    );
    }
}
