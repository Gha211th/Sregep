import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/core/constants.dart';

class SideNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SideNavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<SideNavbar> createState() => _SideNavbarState();
}

class _SideNavbarState extends State<SideNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.accent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 60),
          Text(
            "View your activity:",
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          _navItem(index: 0, icon: Icons.timer_outlined, label: "Focus Mode"),
          _navItem(index: 1, icon: Icons.bar_chart_rounded, label: "Statistic"),
          _navItem(
            index: 2,
            icon: Icons.checklist_rtl_rounded,
            label: "Todo List",
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sregep.",
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 32),
        ),
        Text(
          "[ Focus - Study - Achieve ]",
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = widget.selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => widget.onDestinationSelected(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 15),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
