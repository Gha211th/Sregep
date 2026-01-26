import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/timer_provider.dart';

class SubjectPicker extends StatelessWidget {
  const SubjectPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final subjects = ['MTK', 'IPA', 'IPS', 'Bhs.Indo', 'Bhs.Eng'];

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select The Mapel To Focus",
            style: GoogleFonts.outfit(
              color: const Color(0xFF34A0D3),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          Text(
            '''Here's the core mapel''',
            style: GoogleFonts.outfit(
              color: Color(0xFFB3B3B3),
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: subjects.map((subject) {
                final isSelected = timerProvider.selectedSubject == subject;
                return GestureDetector(
                  onTap: () => timerProvider.selectSubject(subject),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF34A0D3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      subject,
                      style: GoogleFonts.outfit(
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
