import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sregep_productivity_app/data/database_helper.dart';
import 'widgets/subject_picker.dart';
import 'widgets/timer_circle.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final screenWidth = MediaQuery.of(context).size;

    // int getFontsizeForTitle(double width) {
    // if (width >= 1600) ;
    // }

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenWidth.height * 0.08),
                Text(
                  "Focus Mode",
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
                SizedBox(height: screenWidth.height * 0.03),
                SubjectPicker(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TimerCircle(),
                  ),
                ),
                SizedBox(height: screenWidth.height * 0.04),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildControlButtons(timerProvider, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons(TimerProvider provider, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: _buildStartButton(provider, context)),
            const SizedBox(width: 10),
            Expanded(child: _buildStopButton(provider, context)),
          ],
        ),

        const SizedBox(height: 15),

        Visibility(
          visible: !provider.isRunning && provider.currentSeconds > 0,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final String subject = provider.selectedSubject;
                final int duration = provider.currentSeconds;

                await DatabaseHelper.instance.insertStudyRecord({
                  'subject': subject,
                  'duration': duration,
                  'date': DateTime.now().toIso8601String(),
                });

                final allData = await DatabaseHelper.instance.queryAllRows();
                print("ISI DATABASE SEKARANG: $allData");

                provider.restartTimer();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF34A0D3),
                    content: Text(
                      "Sesi $subject selama ${duration}s disimpan! 🎉",
                      style: GoogleFonts.outfit(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34A0D3),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                "Finish!",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(TimerProvider provider, BuildContext context) {
    return ElevatedButton(
      onPressed: provider.isRunning ? null : () => provider.startTimer(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF34A0D3),
        disabledBackgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(100),
        ),
        side: provider.isRunning
            ? const BorderSide(color: Color(0xFF34A0D3), width: 1)
            : BorderSide.none,
      ),
      child: Text(
        "Start Focus",
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: provider.isRunning ? Color(0xFF0077B6) : Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildStopButton(TimerProvider provider, BuildContext context) {
    return ElevatedButton(
      onPressed: !provider.isRunning ? null : () => provider.stopTimer(),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF34A0D3),
        disabledBackgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(100),
        ),
        side: provider.isRunning
            ? BorderSide.none
            : BorderSide(color: Color(0xFF0077B6), width: 1),
      ),
      child: Text(
        "Stop Focus",
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: provider.isRunning ? Colors.white : Color(0xFF0077B6),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
