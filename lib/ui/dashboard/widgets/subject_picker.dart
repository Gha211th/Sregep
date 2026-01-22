import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';
import '../widgets/timer_circle.dart';

class SubjectPicker extends StatelessWidget {
  const SubjectPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final List<String> subjects = ['MTK', 'IPS', 'IPS', 'Bhs.Indo', 'Bhs.Eng'];

    return Column(
      children: [
        Text(
          'Select The Mapel To Focus',
          style: GoogleFonts.outfit(
            color: const Color(0xFF32A0D6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          """Here's the core mapel""",
          style: GoogleFonts.outfit(fontSize: 10, color: Color(0xFFB3B3B3)),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              bool isSelected =
                  timerProvider.selectedSubject == subjects[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  label: Text(subjects[index]),
                  selected: isSelected,
                  onSelected: (_) => timerProvider,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
