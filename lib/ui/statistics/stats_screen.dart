import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:sregep_productivity_app/data/database_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sregep_productivity_app/core/constants.dart';

class StatsScreen extends StatelessWidget {
  const  StatsScreen({super.key});

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
              const SizedBox(height: 30),
              _buildHeader(),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              _buildSectionTitle('Focus Statistic This Week', 'Have you reached your goals'),
              const SizedBox(height: 15),

              _buildChartScetion(),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              _buildMoreDetailHeader(),
              const SizedBox(height: 20),

              _buildSubjectProgressList(),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Stats", style: GoogleFonts.outfit(color: AppColors.accent, fontSize: 36, fontWeight: FontWeight.w500)),
        Text("Productivity stats this week", style: GoogleFonts.outfit(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w500)), 
      ],

    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.outfit(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.w400)),
        Text(subtitle, style: GoogleFonts.outfit(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildChartScetion() {
    return FutureBuilder<List<double>>(
      future: DatabaseHelper.instance.getDailyStats(),
      builder: (context, snapshot) {
        List<double> data = snapshot.data ?? List.filled(7, 0.0);
        double maxVal = data.isEmpty ? 100 : data.reduce((a, b) => a > b ? a : b);

        if (maxVal ==  0) maxVal = 100;
        
        return Container(
          height: 250,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BarChart(BarChartData(
            maxY: 100,
            barGroups: List.generate(7, (i) => _makeBarGroup(i, data[i])),
            titlesData: _buildChartTitles(),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          )),
        );
      }
    );
  }

  Widget _buildSubjectProgressList() {
    return FutureBuilder(future: DatabaseHelper.instance.getSubjectStats(), builder: (context, snapshot){
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No records yet, Start focusing"));
        }

        final stats = snapshot.data!;
        double grandTotal = stats.fold(0, (sum, item) => sum + item['total_duration']);

        return Column(
          children: stats.map((item) {
              double progress = item['total_duration'] / grandTotal;
              return _buildSubjectDetailCard(item['subject'], progress);
            }).toList(),
        );
      }
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.accent,
          width: 14,
          borderRadius: BorderRadius.circular(10),
        )
      ]
    );
  }

  FlTitlesData _buildChartTitles() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (v, m) {
            const day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            return Padding(
              padding: const EdgeInsetsGeometry.only(top: 8),
              child: Text(day[v.toInt()], style: GoogleFonts.outfit(fontSize: 10)),
            );
          }
        )
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTitlesWidget: (v, m) => Text("${v.toInt()}", style: GoogleFonts.outfit(fontSize: 10),)
        )
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false))
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
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.accent)),
          Text("""This week's subject percentage""", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          ClipRect(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.blue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMoreDetailHeader() {
    return Center(
      child: Column(
        children: [
          Text("More Details", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.accent)),
          Text('Focus detail this week', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey))
        ],
      ),
    );
  }
}
