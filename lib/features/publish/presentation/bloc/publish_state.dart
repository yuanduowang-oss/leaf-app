import 'package:equatable/equatable.dart';
import '../../data/models/publish_post.dart';

enum PublishStatus { initial, submitting, success, error }

class PublishState extends Equatable {
  final String title;
  final String content;
  final PublishCategory category;
  final String? evModel;
  final String? imagePath;
  final String? videoPath;
  final PublishStatus status;
  final String? errorMessage;

  const PublishState({
    this.title = '',
    this.content = '',
    this.category = PublishCategory.experience,
    this.evModel,
    this.imagePath,
    this.videoPath,
    this.status = PublishStatus.initial,
    this.errorMessage,
  });

  bool get canSubmit => title.trim().isNotEmpty && content.trim().isNotEmpty;

  PublishState copyWith({
    String? title,
    String? content,
    PublishCategory? category,
    String? evModel,
    String? imagePath,
    String? videoPath,
    PublishStatus? status,
    String? errorMessage,
    bool clearImage = false,
    bool clearVideo = false,
    bool clearEvModel = false,
  }) {
    return PublishState(
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      evModel: clearEvModel ? null : (evModel ?? this.evModel),
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      videoPath: clearVideo ? null : (videoPath ?? this.videoPath),
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [title, content, category, evModel, imagePath, videoPath, status, errorMessage];
}