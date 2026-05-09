import 'package:equatable/equatable.dart';
import '../../data/models/publish_post.dart';

abstract class PublishEvent extends Equatable {
  const PublishEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTitle extends PublishEvent {
  final String title;
  const UpdateTitle(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateContent extends PublishEvent {
  final String content;
  const UpdateContent(this.content);

  @override
  List<Object?> get props => [content];
}

class UpdateCategory extends PublishEvent {
  final PublishCategory category;
  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateEvModel extends PublishEvent {
  final String? evModel;
  const UpdateEvModel(this.evModel);

  @override
  List<Object?> get props => [evModel];
}

class AttachImage extends PublishEvent {
  final String path;
  const AttachImage(this.path);

  @override
  List<Object?> get props => [path];
}

class AttachVideo extends PublishEvent {
  final String path;
  const AttachVideo(this.path);

  @override
  List<Object?> get props => [path];
}

class RemoveMedia extends PublishEvent {
  final bool isImage;
  const RemoveMedia(this.isImage);

  @override
  List<Object?> get props => [isImage];
}

class SubmitPost extends PublishEvent {
  const SubmitPost();
}