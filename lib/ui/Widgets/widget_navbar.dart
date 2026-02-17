import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/ui/dashboard/dashboard_screen.dart';
import 'package:sregep_productivity_app/ui/statistics/stats_screen.dart';
import 'package:sregep_productivity_app/ui/todo_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const DashboardScreen(),
    const StatsScreen(),
    const TodoScreen(),
    //    const Center(child: Text("NOTE STUDENT PAGE *idk about this one")),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: _buildCustomNavbar(),
    );
  }

  Widget _buildCustomNavbar() {
    return Container(
      height: 80,
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 70, vertical: 10),
      decoration: BoxDecoration(color: AppColors.accent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(0, Icons.timer, "Timer"),
          _navItem(1, Icons.stacked_line_chart, "Stats"),
          _navItem(2, Icons.checklist_rtl_rounded, "Todos"),
          //        _navItem(3, Icons.person_rounded, "Profile"),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isActive ? AppColors.accent : Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 0),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: Colors.white,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavbar(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.accent,
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sregep.",
            style: GoogleFonts.outfit(
              color: AppColors.accent,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "[ Focus - Study - Achieve ]",
            style: GoogleFonts.outfit(
              color: AppColors.accent,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 60),
          _navItem(0, Icons.timer, "Focus Timer"),
          _navItem(1, Icons.stacked_line_chart, "Statistic"),
          _navItem(2, Icons.checklist_rtl_rounded, "Todo List"),
        ],
      ),
    );
  }
}
