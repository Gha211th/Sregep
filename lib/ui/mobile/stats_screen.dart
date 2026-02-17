import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'dart:math';

import 'package:sregep_productivity_app/data/repo/study_repo.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedFilter = 'Minggu Ini';
  final List<String> _filterOptions = ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.08),
              _buildHeader(),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              _buildSectionTitle(
                'Focus Statistic This Week',
                'Have you reached your goals?',
              ),
              const SizedBox(height: 15),
              _dropDownOptions(),
              const SizedBox(height: 15),

              _buildChartScetion(),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              _buildMoreDetailHeader(),
              const SizedBox(height: 20),

              _buildSubjectProgressList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedFilter,
          items: _filterOptions.map((String val) {
            return DropdownMenuItem(
              value: val,
              child: Text(
                "$val",
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.accent,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newVal) {
            if (newVal != null) {
              setState(() {
                _selectedFilter = newVal;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Stats",
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 42,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Text(
          "Productivity stats this week",
          style: GoogleFonts.outfit(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.outfit(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildChartScetion() {
    final StudyRepository _studyRepo = StudyRepository();
    return FutureBuilder<List<double>>(
      future: _studyRepo.getDailyStats(range: _selectedFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          );
        }

        List<double> data = snapshot.data ?? [];

        if (data.isEmpty) data = [0.0];

        List<double> charData = data.map((seconds) => seconds / 60).toList();
        if (charData.isEmpty) charData = [0.0];

        double maxData = charData.isEmpty ? 0 : charData.reduce(max);
        double calculateMaxY = maxData < 5 ? 5 : maxData + (maxData * 0.2);
        double dynamicInterval = calculateMaxY / 5;

        return Container(
          height: 250,
          padding: const EdgeInsets.fromLTRB(10, 20, 15, 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: calculateMaxY,
              minY: 0,
              barGroups: List.generate(
                charData.length,
                (i) => _makeBarGroup(i, charData[i], width: _getBarWidth()),
              ),
              titlesData: _buildChartTitles(dataCount: charData.length),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => AppColors.accent,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      "${rod.toY.toStringAsFixed(1)} m",
                      GoogleFonts.outfit(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: dynamicInterval,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
    );
  }

  double _getBarWidth() {
    if (_selectedFilter == 'Minggu Ini') return 8;
    if (_selectedFilter == 'Bulan Ini') return 6;
    return 8;
  }

  Widget _buildSubjectProgressList() {
    final StudyRepository _studyRepo = StudyRepository();
    return FutureBuilder(
      future: _studyRepo.getSubjectStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No records yet, Start focusing"));
        }

        final stats = snapshot.data!;
        double grandTotal = stats.fold(
          0,
          (sum, item) => sum + item['total_duration'],
        );

        return Column(
          children: stats.map((item) {
            double progress = item['total_duration'] / grandTotal;
            return _buildSubjectDetailCard(item['subject'], progress);
          }).toList(),
        );
      },
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, {required double width}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.accent,
          width: width,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  FlTitlesData _buildChartTitles({required int dataCount}) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (v, m) {
            int index = v.toInt();

            if (_selectedFilter == 'Minggu Ini') {
              const days = ['Mon', 'Tues', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              if (index >= 0 && index < days.length) {
                return Text(
                  days[index],
                  style: GoogleFonts.outfit(fontSize: 10),
                );
              }
            }

            if (_selectedFilter == 'Bulan Ini') {
              if (index % 3 == 0 && index < 31) {
                return Text(
                  "${index + 1}",
                  style: GoogleFonts.outfit(fontSize: 9),
                );
              }
            }

            if (_selectedFilter == 'Tahun Ini') {
              const month = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              if (index >= 0 && index < month.length && index % 1 == 0) {
                return Text(
                  month[index],
                  style: GoogleFonts.outfit(fontSize: 9),
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          interval: 25,
          getTitlesWidget: (v, m) =>
              Text("${v.toInt()}m", style: GoogleFonts.outfit(fontSize: 10)),
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _buildSubjectDetailCard(String title, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.accent,
            ),
          ),
          Text(
            """This week's subject percentage""",
            style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ClipRect(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreDetailHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            "More Details",
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.accent,
            ),
          ),
          Text(
            'Focus detail this week',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
