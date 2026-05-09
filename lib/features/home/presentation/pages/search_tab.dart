import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _hotSearches = ['特斯拉 AP', '充电桩安装', '冬季续航', '比亚迪汉', '蔚来ET7', '特斯拉充电', '电动车保险'];
  final List<String> _historySearches = [];
  List<String> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _historySearches.clear();
      _historySearches.addAll(history);
    });
  }

  Future<void> _addToHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    history.remove(query);
    history.insert(0, query);
    if (history.length > 10) history.removeLast();
    await prefs.setStringList('search_history', history);
    _loadHistory();
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() => _historySearches.clear());
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _isSearching = true;
      _searchResults = [
        '特斯拉 Model 3 冬季续航实测',
        '比亚迪汉 EV 充电桩安装指南',
        '如何开启特斯拉 Autopilot',
        '蔚来ET7 高速续航测试',
      ].where((s) => s.contains(query)).toList();
    });
    _addToHistory(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: '搜索车型、问题、技巧...',
                  hintStyle: const TextStyle(color: AppTheme.textHint),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                  filled: true,
                  fillColor: AppTheme.surfaceDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textHint, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() { _isSearching = false; });
                    },
                  ),
                ),
                onSubmitted: _performSearch,
                onChanged: (v) {
                  if (v.isEmpty) setState(() { _isSearching = false; });
                },
              ),
            ),

            // Search Results or Content
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildSearchContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('未找到相关结果', style: TextStyle(color: AppTheme.textHint)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(8)),
          child: Text(_searchResults[index], style: const TextStyle(color: AppTheme.textPrimary)),
        );
      },
    );
  }

  Widget _buildSearchContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('热门搜索', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _hotSearches.map((keyword) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = keyword;
                  _performSearch(keyword);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(20)),
                  child: Text(keyword, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('搜索历史', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              if (_historySearches.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.textHint, size: 20),
                  onPressed: _clearHistory,
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_historySearches.isEmpty)
            const Text('暂无搜索历史', style: TextStyle(color: AppTheme.textHint))
          else
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _historySearches.map((keyword) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = keyword;
                    _performSearch(keyword);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, color: AppTheme.textHint, size: 16),
                        const SizedBox(width: 6),
                        Text(keyword, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 32),

          const Text('快捷入口', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildQuickAccessGrid(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    final items = [
      {'icon': Icons.bolt, 'label': '充电桩', 'color': AppTheme.primaryGreen},
      {'icon': Icons.compare, 'label': '车型对比', 'color': AppTheme.categoryTips},
      {'icon': Icons.question_answer, 'label': '问答', 'color': AppTheme.categoryProblem},
      {'icon': Icons.build, 'label': '保养', 'color': const Color(0xFF9C27B0)},
      {'icon': Icons.branding_watermark, 'label': '品牌', 'color': const Color(0xFFE91E63)},
      {'icon': Icons.local_offer, 'label': '优惠', 'color': const Color(0xFFFF9800)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
              const SizedBox(height: 8),
              Text(
                item['label'] as String,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
