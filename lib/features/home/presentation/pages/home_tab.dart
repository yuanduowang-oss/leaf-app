import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/post.dart';
import '../../../../features/video_player/presentation/pages/video_player_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _categories = ['推荐', '新能源', '热门', '问题解决', '保养'];
  
  final Map<String, PostCategory?> _categoryMap = {
    '推荐': null,
    '新能源': PostCategory.experience,
    '热门': PostCategory.tips,
    '问题解决': PostCategory.problemSolving,
    '保养': PostCategory.maintenance,
  };

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadPosts());
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
            // App Bar
            _buildAppBar(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Category Tabs
            _buildCategoryTabs(),
            
            // Content List
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.status == HomeStatus.loading && state.posts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                    );
                  }
                  
                  if (state.posts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textHint),
                          const SizedBox(height: 16),
                          Text(
                            '暂无内容',
                            style: TextStyle(color: AppTheme.textHint, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    color: AppTheme.primaryGreen,
                    backgroundColor: AppTheme.surfaceDark,
                    onRefresh: () async {
                      context.read<HomeBloc>().add(const RefreshPosts());
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView(
                      padding: const EdgeInsets.only(top: 12, bottom: 100),
                      children: [
                        // Featured Banner (大视频/图片)
                        _buildFeaturedBanner(state.posts.first),
                        
                        // Content Grid
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '热门内容',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  '查看更多',
                                  style: TextStyle(color: AppTheme.primaryGreen),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        _buildContentGrid(state.posts.skip(1).toList()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Text(
            'Leaf',
            style: TextStyle(
              color: AppTheme.primaryGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: '搜索车型、问题、技巧...',
          hintStyle: const TextStyle(color: AppTheme.textHint),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
          filled: true,
          fillColor: AppTheme.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSubmitted: (value) {
          context.read<HomeBloc>().add(SearchPosts(value));
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final selectedIndex = _categories.indexWhere((cat) {
          final mappedCat = _categoryMap[cat];
          return mappedCat == state.selectedCategory;
        });
        
        return Container(
          height: 44,
          margin: const EdgeInsets.only(top: 12),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeBloc>().add(
                      SelectCategory(_categoryMap[_categories[index]]),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBanner(Post post) {
    return GestureDetector(
      onTap: () => _showPostDetail(post),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 220,
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: post.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          post.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 220,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 220,
                              color: AppTheme.primaryGreen.withOpacity(0.15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.eco, size: 48, color: AppTheme.primaryGreen),
                                  const SizedBox(height: 8),
                                  Text(post.authorName, style: TextStyle(color: AppTheme.primaryGreen, fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            post.videoUrl != null ? Icons.play_circle_fill : Icons.image,
                            size: 48,
                            color: AppTheme.textHint,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.authorName,
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
              ),
            ),
            if (post.videoUrl != null && post.videoUrl!.isNotEmpty)
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(post.category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.categoryLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.content,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.play_circle_outline, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(_formatCount(post.likesCount), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(_formatCount(post.commentsCount), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentGrid(List<Post> posts) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return _buildContentCard(posts[index]);
        },
      ),
    );
  }

  Widget _buildContentCard(Post post) {
    final categoryColor = _getCategoryColor(post.category);
    
    return GestureDetector(
      onTap: () => _showPostDetail(post),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.15),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: post.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              post.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryGreen,
                                    strokeWidth: 2,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: AppTheme.primaryGreen.withOpacity(0.25),
                                  child: Center(
                                    child: Icon(
                                      post.videoUrl != null ? Icons.play_circle_fill : Icons.image,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              post.videoUrl != null ? Icons.play_circle_outline : Icons.image,
                              size: 48,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            post.videoUrl != null ? '视频' : '图文',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.categoryLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.content,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 12, color: AppTheme.textHint),
                      const SizedBox(width: 4),
                      Text(_formatCount(post.likesCount), style: TextStyle(color: AppTheme.textHint, fontSize: 11)),
                      const SizedBox(width: 8),
                      Icon(Icons.chat_bubble_outline, size: 12, color: AppTheme.textHint),
                      const SizedBox(width: 4),
                      Text(_formatCount(post.commentsCount), style: TextStyle(color: AppTheme.textHint, fontSize: 11)),
                    ],
                  ),
                ],
              ),
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

  void _showPostDetail(Post post) {
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
}