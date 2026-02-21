import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/core/constants.dart';

class DetailCard extends StatelessWidget {
  
  final String title;
  final double progress;

  const DetailCard({super.key, required this.title, required this.progress});

  @override
  Widget build(BuildContext context) {
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
}


