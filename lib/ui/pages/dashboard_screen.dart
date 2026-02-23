import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/ui/Widgets/timer/normal_timer.dart';
import 'package:sregep_productivity_app/ui/Widgets/subject-picker/subject_picker.dart';
import 'package:sregep_productivity_app/ui/Widgets/timer/timer_circle-tablet.dart';
import 'package:sregep_productivity_app/ui/Widgets/timer/timer_circle.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';
import 'package:sregep_productivity_app/data/repo/study_repo.dart';
import 'package:sregep_productivity_app/ui/pages/card-detail/subject_detail.dart';
import 'package:sregep_productivity_app/ui/fonts/font_size.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1000) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _buildDesktopMode(context, timerProvider),
              );
            }
            if (constraints.maxWidth > 600) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                physics: const BouncingScrollPhysics(),
                child: _buildTabletMode(context, timerProvider),
              );
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _buildMobileMode(context, timerProvider),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileMode(BuildContext context, TimerProvider provider) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.06),
          _buildWelcomeUser(context),
          SizedBox(height: screenSize.height * 0.01),
          const Divider(thickness: 1),
          SizedBox(height: screenSize.height * 0.04),
          SubjectPicker(),
          Center(
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
              child: TimerCircle(),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          _buildTimerControls(context, provider),
          SizedBox(height: screenSize.height * 0.04),
          Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: _buildControlButtons(provider, context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletMode(BuildContext context, TimerProvider provider) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height * 0.06),
        _buildWelcomeUser(context),
        SizedBox(height: screenSize.height * 0.04),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SubjectPicker(),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(vertical: 15),
            child: TimerCircleTablet(),
          ),
        ),
        SizedBox(height: screenSize.height * 0.03),
        _buildTimerControls(context, provider),
        SizedBox(height: screenSize.height * 0.04),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: _buildControlButtons(provider, context),
        ),
      ],
    );
  }

  Widget _buildDesktopMode(BuildContext context, TimerProvider provider) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height * 0.06),
        _buildWelcomeUser(context),
        SizedBox(height: screenSize.height * 0.02),
        const Divider(thickness: 1),
        SizedBox(height: screenSize.height * 0.04),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const SubjectPicker(),
                    ),
                    SizedBox(height: screenSize.height * 0.06),
                    const NormalTimer(),
                    SizedBox(height: screenSize.height * 0.04),
                    _buildTimerControls(context, provider),
                    const SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                      ),
                      child: _buildControlButtons(provider, context),
                    ),
                    SizedBox(height: screenSize.height * 0.15),
                    const Divider(thickness: 2),
                  ],
                ),
              ),
              SizedBox(width: screenSize.width * 0.02),
              const VerticalDivider(thickness: 1.5),
              SizedBox(width: screenSize.width * 0.02),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMoreDetailHeader(context),
                    const SizedBox(height: 30),
                    _buildStatsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // [ WIDGET CONTROL BUTTON BUAT TIMER ]

  Widget _buildControlButtons(TimerProvider provider, BuildContext context) {
    final studyRepo = StudyRepository();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: _buildStartButton(provider, context)),
            const SizedBox(width: 40),
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

                await studyRepo.insertStudyRecord({
                  'subject': subject,
                  'duration': duration,
                  'date': DateTime.now().toIso8601String(),
                });

                final allData = await studyRepo.queryAllRows();
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

  Widget _buildTimerControls(BuildContext context, TimerProvider provider) {
    final bool isRunning = provider.isRunning;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _timeActionButton(
          icon: Icons.remove,
          onPressed: isRunning ? null : () => provider.adjustSeconds(-300),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () => provider.restartTimer(),
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 20),
        _timeActionButton(
          icon: Icons.add,
          onPressed: isRunning ? null : () => provider.adjustSeconds(300),
        ),
      ],
    );
  }

  // [ BUAT STYLING DASAR ]

  Widget _timeActionButton({required IconData icon, VoidCallback? onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(shape: const CircleBorder()),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  // [ WIDGET TEXT, TITLE DAN KAWAN-KAWAN ]

  Widget _buildWelcomeUser(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Focus Timer",
          style: GoogleFonts.outfit(
            fontSize: ResponsiveText.getTitleSize(context),
            fontWeight: FontWeight.w500,
            height: 1,
            color: AppColors.accent,
          ),
        ),
        Text(
          "Ready to be productive?",
          style: GoogleFonts.outfit(
            fontSize: ResponsiveText.getSubTitleFontSize(context),
            fontWeight: FontWeight.w400,
            color: const Color(0xffB3B3B3),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreDetailHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "More Details",
          style: GoogleFonts.outfit(
            fontSize: ResponsiveText.getMoreDetailFontSize(context),
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
            height: 1,
          ),
        ),
        Text(
          'Focus detail this week',
          style: GoogleFonts.outfit(
            fontSize: ResponsiveText.getFontForSubDetail(context),
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // [ WIDGET STATISTIK BELAJAR ]

  Widget _buildStatsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: StudyRepository().getSubjectStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "Belum ada statistik belajar.",
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
          );
        }

        // 1. Hitung total durasi seluruhnya untuk kalkulasi progress bar %
        double grandTotal = snapshot.data!.fold(
          0,
          (sum, item) => sum + (item['total_duration'] as num).toDouble(),
        );

        // 2. Gunakan Column atau ListView untuk menampilkan SEMUA data
        return Column(
          children: snapshot.data!.map((data) {
            final String subjectName = data['subject'];
            final double totalDuration = (data['total_duration'] as num)
                .toDouble();

            // Kalkulasi progress relatif terhadap total keseluruhan
            double progressValue = grandTotal > 0
                ? totalDuration / grandTotal
                : 0;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
              ), // Beri jarak antar card
              child: DetailCard(title: subjectName, progress: progressValue),
            );
          }).toList(),
        );
      },
    );
  }
}
