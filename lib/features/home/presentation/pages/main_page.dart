import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'qa_tab.dart';
import 'profile_tab.dart';
import '../../../charging/presentation/pages/charging_map_tab.dart';
import '../../../comparison/presentation/pages/car_comparison_tab.dart';
import '../../../publish/presentation/pages/publish_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeTab(),
    ChargingMapTab(),
    CarComparisonTab(),
    QATab(),
    ProfileTab(),
  ];

  void _openPublish() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PublishPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      floatingActionButton: GestureDetector(
        onTap: _openPublish,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: AppTheme.cardDark, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, '首页', 0),
              _buildNavItem(Icons.bolt_outlined, Icons.bolt, '充电', 1),
              const SizedBox(width: 56),
              _buildNavItem(Icons.compare_outlined, Icons.compare, '对比', 2),
              _buildNavItem(Icons.question_answer_outlined, Icons.question_answer, '问答', 3),
              _buildNavItem(Icons.person_outline, Icons.person, '我的', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData selectedIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}