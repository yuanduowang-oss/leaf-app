import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/firestore_post_repository.dart';
import '../../../../data/models/post.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _repo = FirestorePostRepository();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController(text: '电车老王');
  final _evModelController = TextEditingController();
  final _locationController = TextEditingController(text: '北京');

  PostCategory _selectedCategory = PostCategory.experience;
  bool _isSubmitting = false;
  String? _message;
  bool _messageIsError = false;
  List<Post> _recentPosts = [];
  bool _loadingPosts = true;

  @override
  void initState() {
    super.initState();
    _loadRecentPosts();
  }

  Future<void> _loadRecentPosts() async {
    try {
      final posts = await _repo.getPosts();
      if (mounted) {
        setState(() {
          _recentPosts = posts;
          _loadingPosts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingPosts = false);
        _showMessage('加载失败: $e', true);
      }
    }
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showMessage('内容不能为空', true);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = null;
    });

    try {
      await _repo.addPost(
        authorName: _authorController.text.trim().isEmpty
            ? '匿名用户'
            : _authorController.text.trim(),
        content: content,
        category: _selectedCategory,
        imageUrl: _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : null,
        videoUrl: _videoUrlController.text.trim().isNotEmpty
            ? _videoUrlController.text.trim()
            : null,
        evModel: _evModelController.text.trim().isNotEmpty
            ? _evModelController.text.trim()
            : null,
        location: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
      );

      // 清空表单
      _contentController.clear();
      _imageUrlController.clear();
      _videoUrlController.clear();
      _evModelController.clear();

      _showMessage('发布成功！刷新叶子APP即可看到', false);
      _loadRecentPosts();
    } catch (e) {
      _showMessage('发布失败: $e', true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deletePost(String id) async {
    try {
      await _repo.deletePost(id);
      _showMessage('已删除', false);
      _loadRecentPosts();
    } catch (e) {
      _showMessage('删除失败: $e', true);
    }
  }

  void _showMessage(String msg, bool isError) {
    if (mounted) {
      setState(() {
        _message = msg;
        _messageIsError = isError;
      });
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _evModelController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: AppTheme.primaryGreen, size: 24),
            SizedBox(width: 8),
            Text('内容管理', style: TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 消息提示
            if (_message != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _messageIsError
                      ? Colors.red.withOpacity(0.2)
                      : AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _messageIsError ? Icons.error : Icons.check_circle,
                      color: _messageIsError ? Colors.red : AppTheme.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _message!,
                        style: TextStyle(
                          color: _messageIsError ? Colors.red : AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 快速发布卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '快速发布',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 内容
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: '写点内容...',
                      hintStyle: const TextStyle(color: AppTheme.textHint),
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 5,
                    minLines: 3,
                  ),
                  const SizedBox(height: 12),

                  // 图片URL
                  TextField(
                    controller: _imageUrlController,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: '图片URL (粘贴Unsplash/图床链接)',
                      hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
                      prefixIcon: const Icon(Icons.image, color: AppTheme.textHint, size: 20),
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 视频URL
                  TextField(
                    controller: _videoUrlController,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: '视频URL (选填，HTTPS直链)',
                      hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
                      prefixIcon: const Icon(Icons.videocam, color: AppTheme.textHint, size: 20),
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 分类
                  const Text('分类', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PostCategory.values.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      final label = _catLabel(cat);
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // 车型和地区
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _evModelController,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: '车型 (选填)',
                            hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
                            prefixIcon: const Icon(Icons.directions_car, color: AppTheme.textHint, size: 20),
                            filled: true,
                            fillColor: AppTheme.surfaceDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _locationController,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: '地区 (选填)',
                            hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
                            prefixIcon: const Icon(Icons.location_on, color: AppTheme.textHint, size: 20),
                            filled: true,
                            fillColor: AppTheme.surfaceDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 作者
                  TextField(
                    controller: _authorController,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: '作者名',
                      hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
                      prefixIcon: const Icon(Icons.person, color: AppTheme.textHint, size: 20),
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 发布按钮
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        disabledBackgroundColor: AppTheme.primaryGreen.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '立即发布',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 已发布列表
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '已发布的内容',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _loadRecentPosts,
                  child: const Text('刷新', style: TextStyle(color: AppTheme.primaryGreen)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_loadingPosts)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                ),
              )
            else if (_recentPosts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('还没有内容，快来发布第一条吧！',
                      style: TextStyle(color: AppTheme.textHint)),
                ),
              )
            else
              ..._recentPosts.map((post) => _buildPostCard(post)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  post.categoryLabel,
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 10,
                  ),
                ),
              ),
              if (post.evModel != null) ...[
                const SizedBox(width: 8),
                Icon(Icons.directions_car, size: 12, color: AppTheme.textHint),
                const SizedBox(width: 4),
                Text(post.evModel!, style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                onPressed: () => _deletePost(post.id),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 12, color: AppTheme.textHint),
              const SizedBox(width: 4),
              Text(post.authorName, style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
              const Spacer(),
              Icon(
                post.imageUrl != null ? Icons.image : Icons.text_snippet,
                size: 14,
                color: AppTheme.textHint,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _catLabel(PostCategory cat) {
    switch (cat) {
      case PostCategory.experience:
        return '经验';
      case PostCategory.tips:
        return '技巧';
      case PostCategory.problemSolving:
        return '问题解决';
      case PostCategory.maintenance:
        return '保养';
    }
  }
}
