import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _navigateTo(BuildContext context, String label) {
    if (label == '设置') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
    }
    // 其他菜单项...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: AppTheme.primaryGreen, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('电车车主', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('比亚迪 汉EV 车主', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppTheme.textSecondary),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('12', '发布'),
                        _buildDivider(),
                        _buildStat('856', '关注'),
                        _buildDivider(),
                        _buildStat('2.3k', '粉丝'),
                        _buildDivider(),
                        _buildStat('1.2k', '获赞'),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(color: AppTheme.surfaceDark, height: 1),

              _buildMenuSection('我的内容', [
                {'icon': Icons.article_outlined, 'label': '我的发布', 'badge': '12'},
                {'icon': Icons.bookmark_outline, 'label': '我的收藏', 'badge': null},
                {'icon': Icons.history, 'label': '浏览历史', 'badge': null},
              ], context),

              _buildMenuSection('互动', [
                {'icon': Icons.thumb_up_outlined, 'label': '我的点赞', 'badge': null},
                {'icon': Icons.chat_bubble_outline, 'label': '我的评论', 'badge': null},
                {'icon': Icons.notifications_outlined, 'label': '消息通知', 'badge': '3'},
              ], context),

              _buildMenuSection('车辆', [
                {'icon': Icons.directions_car_outlined, 'label': '我的车辆', 'badge': null},
                {'icon': Icons.bolt_outlined, 'label': '充电记录', 'badge': null},
                {'icon': Icons.build_outlined, 'label': '保养记录', 'badge': null},
              ], context),

              _buildMenuSection('其他', [
                {'icon': Icons.settings_outlined, 'label': '设置', 'badge': null},
                {'icon': Icons.help_outline, 'label': '帮助与反馈', 'badge': null},
                {'icon': Icons.info_outline, 'label': '关于 Leaf', 'badge': null},
              ], context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildDivider() => Container(width: 1, height: 30, color: AppTheme.surfaceDark);

  Widget _buildMenuSection(String title, List<Map<String, dynamic>> items, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item['icon'] as IconData, color: AppTheme.textSecondary, size: 22),
                    title: Text(item['label'] as String, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item['badge'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(10)),
                            child: Text(item['badge'] as String, style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: AppTheme.textHint),
                      ],
                    ),
                    onTap: () => _navigateTo(context, item['label'] as String),
                  ),
                  if (index < items.length - 1)
                    const Divider(color: AppTheme.surfaceDark, height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
