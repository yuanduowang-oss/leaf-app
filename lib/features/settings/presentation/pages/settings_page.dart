import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('设置', style: TextStyle(color: AppTheme.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('账号设置', [
              _buildMenuItem(Icons.person_outline, '个人信息', onTap: () {}),
              _buildMenuItem(Icons.lock_outline, '账号安全', onTap: () {}),
              _buildMenuItem(Icons.notifications_outlined, '消息通知', trailing: _buildSwitch(true), onTap: () {}),
              _buildMenuItem(Icons.language, '语言/语言', trailing: const Text('中文', style: TextStyle(color: AppTheme.textHint)), onTap: () {}),
            ]),

            _buildSection('显示', [
              _buildMenuItem(Icons.dark_mode_outlined, '深色模式', trailing: _buildSwitch(true), onTap: () {}),
              _buildMenuItem(Icons.text_fields, '字体大小', trailing: const Text('标准', style: TextStyle(color: AppTheme.textHint)), onTap: () {}),
            ]),

            _buildSection('隐私', [
              _buildMenuItem(Icons.visibility_off_outlined, '隐藏点赞列表', trailing: _buildSwitch(false), onTap: () {}),
              _buildMenuItem(Icons.block, '黑名单', onTap: () {}),
              _buildMenuItem(Icons.privacy_tip_outlined, '隐私政策', onTap: () {}),
            ]),

            _buildSection('支持', [
              _buildMenuItem(Icons.help_outline, '帮助中心', onTap: () {}),
              _buildMenuItem(Icons.feedback_outlined, '意见反馈', onTap: () {}),
              _buildMenuItem(Icons.info_outline, '关于我们', onTap: () {}),
              _buildMenuItem(Icons.star_outline, '给我们评分', onTap: () {}),
            ]),

            _buildSection('其他', [
              _buildMenuItem(Icons.download_outlined, '检查更新', trailing: const Text('已是最新', style: TextStyle(color: AppTheme.textHint)), onTap: () {}),
              _buildMenuItem(Icons.cleaning_services_outlined, '清理缓存', trailing: const Text('23.5MB', style: TextStyle(color: AppTheme.textHint)), onTap: () => _showClearCacheDialog(context)),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _showLogoutDialog(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppTheme.cardDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('退出登录', style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Center(child: Text('Leaf v1.0.0', style: TextStyle(color: AppTheme.textHint, fontSize: 12))),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
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
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary, size: 22),
      title: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textHint),
      onTap: onTap,
    );
  }

  Widget _buildSwitch(bool value) {
    return Switch.adaptive(
      value: value,
      onChanged: (_) {},
      activeColor: AppTheme.primaryGreen,
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('清理缓存', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('确定清理缓存吗？', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清理'), backgroundColor: AppTheme.primaryGreen),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('退出登录', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('确定退出当前账号？', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Firebase logout
            },
            child: const Text('退出', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
