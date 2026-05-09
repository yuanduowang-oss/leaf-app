import 'package:equatable/equatable.dart';
import '../../../../data/models/post.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends HomeEvent {
  final PostCategory? category;
  const LoadPosts({this.category});

  @override
  List<Object?> get props => [category];
}

class RefreshPosts extends HomeEvent {
  const RefreshPosts();
}

class LikePost extends HomeEvent {
  final String postId;
  const LikePost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class SelectCategory extends HomeEvent {
  final PostCategory? category;
  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchPosts extends HomeEvent {
  final String query;
  const SearchPosts(this.query);

  @override
  List<Object?> get props => [query];
}