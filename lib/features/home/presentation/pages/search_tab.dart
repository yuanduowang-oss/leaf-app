import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/post.dart';
import '../../../../data/mock/mock_posts.dart';
import '../../../../features/video_player/presentation/pages/video_player_page.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _hotSearches = ['特斯拉', '比亚迪', '充电桩', '续航', '蔚来', 'Model Y', '理想', '冬季续航'];
  final List<String> _historySearches = [];
  List<Post> _searchResults = [];
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
      _searchResults = MockPosts.getPosts(searchQuery: query.trim());
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
                autofocus: true,
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 56, color: AppTheme.textHint),
            SizedBox(height: 12),
            Text('未找到相关结果，换个关键词试试', style: TextStyle(color: AppTheme.textHint)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) => _buildResultCard(_searchResults[index]),
    );
  }

  Widget _buildResultCard(Post post) {
    final categoryColor = _getCategoryColor(post.category);
    return GestureDetector(
      onTap: () => _openPost(post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    post.categoryLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                if (post.videoUrl != null)
                  const Icon(Icons.play_circle_outline, size: 16, color: AppTheme.primaryGreen),
                const Spacer(),
                Text(
                  post.authorName,
                  style: const TextStyle(color: AppTheme.textHint, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.content,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.favorite_outline, size: 13, color: AppTheme.textHint),
                const SizedBox(width: 4),
                Text(_formatCount(post.likesCount), style: const TextStyle(color: AppTheme.textHint, fontSize: 11)),
                const SizedBox(width: 12),
                Icon(Icons.chat_bubble_outline, size: 13, color: AppTheme.textHint),
                const SizedBox(width: 4),
                Text(_formatCount(post.commentsCount), style: const TextStyle(color: AppTheme.textHint, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(PostCategory category) {
    switch (category) {
      case PostCategory.experience:
        return AppTheme.categoryExperience;
      case PostCategory.tips:
        return AppTheme.categoryTips;
      case PostCategory.problemSolving:
        return AppTheme.categoryProblem;
      case PostCategory.maintenance:
        return const Color(0xFF9C27B0);
    }
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  void _openPost(Post post) {
    if (post.videoUrl != null && post.videoUrl!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            videoUrl: post.videoUrl!,
            title: post.content,
            authorName: post.authorName,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('查看帖子: ${post.content.substring(0, post.content.length > 20 ? 20 : post.content.length)}...'),
          backgroundColor: AppTheme.surfaceDark,
        ),
      );
    }
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
