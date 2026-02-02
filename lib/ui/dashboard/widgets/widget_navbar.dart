import 'package:flutter/material.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/ui/dashboard/dashboard_screen.dart';
import 'package:sregep_productivity_app/ui/statistics/stats_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screen = [
    const DashboardScreen(),
    const StatsScreen(),
  ];

  @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;            
          });
        },
        children: _screen,
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats'
          )
        ],
      ),
    );
  }
  
}
