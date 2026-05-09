import 'package:equatable/equatable.dart';
import '../../../../data/models/post.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Post> posts;
  final PostCategory? selectedCategory;
  final String? errorMessage;
  final bool hasReachedMax;

  const HomeState({
    this.status = HomeStatus.initial,
    this.posts = const [],
    this.selectedCategory,
    this.errorMessage,
    this.hasReachedMax = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Post>? posts,
    PostCategory? selectedCategory,
    String? errorMessage,
    bool? hasReachedMax,
    bool clearCategory = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, posts, selectedCategory, errorMessage, hasReachedMax];
}