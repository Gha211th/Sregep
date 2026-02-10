import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import '../../../providers/timer_provider.dart';

class SubjectPicker extends StatelessWidget {
  const SubjectPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    // final screenWidth = size.width;

    final timerProvider = Provider.of<TimerProvider>(context);
    final List<String> subjects = ['MTK', 'IPA', 'IPS', 'Bhs.Indo', 'Bhs.Eng'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Select Mapel To Focus",
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
          ),
        ),
        Text(
          "What you wanna learn?",
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB3B3B3),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accent, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: subjects.contains(timerProvider.selectedSubject)
                  ? timerProvider.selectedSubject
                  : subjects[0],
              isExpanded: true,
              menuMaxHeight: 250,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: subjects.map((String subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text("Mapel: $subject"),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  timerProvider.selectSubject(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
