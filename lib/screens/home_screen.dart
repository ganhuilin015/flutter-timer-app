import 'package:flutter/material.dart';
import 'package:timer/providers/theme_provider.dart';
import 'timer_screen.dart';
import 'package:provider/provider.dart';
// import 'stopwatch_screen.dart';
// import 'alarm_screen.dart';
// import 'world_clock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<_TabItem> _tabs = const [
    _TabItem(
      icon: Icons.timer_outlined,
      activeIcon: Icons.timer,
      label: 'Timer',
    ),
    _TabItem(
      icon: Icons.av_timer_outlined,
      activeIcon: Icons.av_timer,
      label: 'Stopwatch',
    ),
    _TabItem(
      icon: Icons.alarm_outlined,
      activeIcon: Icons.alarm,
      label: 'Alarm',
    ),
    _TabItem(
      icon: Icons.language_outlined,
      activeIcon: Icons.language,
      label: 'World',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TimerScreen(),
          // StopwatchScreen(),
          // AlarmScreen(),
          // WorldClockScreen(),
        ],
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    final themeColor = context.watch<ThemeProvider>();

    return Container(
      decoration: BoxDecoration(
        color: themeColor.surface(context),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final tab = _tabs[i];
              final isActive = i == _currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            key: ValueKey(isActive),
                            color: isActive
                                ? themeColor.primary(context)
                                : themeColor.onSurface(context),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isActive
                                ? themeColor.primary(context)
                                : themeColor.onSurface(context),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
