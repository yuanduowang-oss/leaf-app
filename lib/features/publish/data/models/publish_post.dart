import 'package:equatable/equatable.dart';

enum PublishCategory {
  experience('经验', 'experience'),
  tips('技巧', 'tips'),
  problemSolving('问题解决', 'problem_solving'),
  maintenance('保养', 'maintenance');

  final String label;
  final String value;
  const PublishCategory(this.label, this.value);
}

class PublishPost extends Equatable {
  final String title;
  final String content;
  final String? imagePath;
  final String? videoPath;
  final PublishCategory category;
  final String? evModel;

  const PublishPost({
    required this.title,
    required this.content,
    this.imagePath,
    this.videoPath,
    required this.category,
    this.evModel,
  });

  bool get hasMedia => imagePath != null || videoPath != null;

  @override
  List<Object?> get props => [title, content, imagePath, videoPath, category, evModel];
}