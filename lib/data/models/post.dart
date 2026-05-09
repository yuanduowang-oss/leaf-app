import 'package:equatable/equatable.dart';

enum PostCategory {
  experience,  // 经验
  tips,        // 技巧
  problemSolving, // 问题解决
  maintenance, // 保养
}

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final Map<String, String> contentTranslations; // locale -> content
  final String? imageUrl;
  final String? videoUrl;
  final PostCategory category;
  final String? evModel;
  final String? location;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.contentTranslations = const {},
    this.imageUrl,
    this.videoUrl,
    required this.category,
    this.evModel,
    this.location,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    Map<String, String>? contentTranslations,
    String? imageUrl,
    String? videoUrl,
    PostCategory? category,
    String? evModel,
    String? location,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      contentTranslations: contentTranslations ?? this.contentTranslations,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      category: category ?? this.category,
      evModel: evModel ?? this.evModel,
      location: location ?? this.location,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get categoryLabel {
    switch (category) {
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

  @override
  List<Object?> get props => [id, authorId, content, category, createdAt];
}