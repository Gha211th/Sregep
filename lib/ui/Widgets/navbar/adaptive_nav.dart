import 'package:flutter/material.dart';
import 'side_navbar.dart';
import 'bot_navbar.dart';
import 'package:sregep_productivity_app/ui/pages/dashboard_screen.dart';
import 'package:sregep_productivity_app/ui/pages/stats_screen.dart';
import 'package:sregep_productivity_app/ui/pages/todo_screen.dart';

class AdaptiveNavigation extends StatefulWidget {
  const AdaptiveNavigation({super.key});

  @override
  State<AdaptiveNavigation> createState() => _AdaptiveNavigationState();
}

class _AdaptiveNavigationState extends State<AdaptiveNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const StatsScreen(),
    const TodoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return Scaffold(
            body: Row(
              children: [
                SideNavbar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                ),
                Expanded(child: _pages[_currentIndex]),
              ],
            ),
          );
        }
        return Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavbarMobile(
            selectedIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        );
      },
    );
  }
}
