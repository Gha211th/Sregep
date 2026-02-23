import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavbarMobile extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavbarMobile({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF34A0D3), // Warna biru background navbar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, "Home"),
          _buildNavItem(1, Icons.bar_chart_rounded, "Stats"),
          _buildNavItem(2, Icons.checklist_rounded, "Todos"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFF34A0D3) : Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
