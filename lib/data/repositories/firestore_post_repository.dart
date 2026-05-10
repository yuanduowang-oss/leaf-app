import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class FirestorePostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'posts';

  /// 发布新帖子
  Future<void> addPost({
    required String authorName,
    required String content,
    required PostCategory category,
    String? imageUrl,
    String? videoUrl,
    String? evModel,
    String? location,
  }) async {
    await _firestore.collection(_collection).add({
      'authorId': 'admin',
      'authorName': authorName,
      'content': content,
      'category': category.name,
      'imageUrl': imageUrl ?? '',
      'videoUrl': videoUrl ?? '',
      'evModel': evModel ?? '',
      'location': location ?? '',
      'likesCount': 0,
      'commentsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 获取帖子列表
  Future<List<Post>> getPosts({PostCategory? category, String? searchQuery}) async {
    Query query = _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }

    final snapshot = await query.get();

    var posts = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Post(
        id: doc.id,
        authorId: data['authorId'] ?? '',
        authorName: data['authorName'] ?? '',
        content: data['content'] ?? '',
        imageUrl: (data['imageUrl'] as String?)?.isNotEmpty == true
            ? data['imageUrl']
            : null,
        videoUrl: (data['videoUrl'] as String?)?.isNotEmpty == true
            ? data['videoUrl']
            : null,
        category: _parseCategory(data['category'] ?? 'experience'),
        evModel: (data['evModel'] as String?)?.isNotEmpty == true
            ? data['evModel']
            : null,
        location: (data['location'] as String?)?.isNotEmpty == true
            ? data['location']
            : null,
        likesCount: data['likesCount'] ?? 0,
        commentsCount: data['commentsCount'] ?? 0,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();

    // 客户端搜索过滤
    if (searchQuery != null && searchQuery.isNotEmpty) {
      posts = posts.where((p) =>
          p.content.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (p.evModel?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    return posts;
  }

  /// 删除帖子
  Future<void> deletePost(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  PostCategory _parseCategory(String value) {
    switch (value) {
      case 'tips':
        return PostCategory.tips;
      case 'problemSolving':
        return PostCategory.problemSolving;
      case 'maintenance':
        return PostCategory.maintenance;
      default:
        return PostCategory.experience;
    }
  }
}
