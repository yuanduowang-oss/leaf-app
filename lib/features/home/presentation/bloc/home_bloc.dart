import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_posts.dart';
import '../../../../data/models/post.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadPosts>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<LikePost>(_onLikePost);
    on<SelectCategory>(_onSelectCategory);
    on<SearchPosts>(_onSearchPosts);
  }

  void _onLoadPosts(LoadPosts event, Emitter<HomeState> emit) async {
    if (state.status == HomeStatus.loading) return;
    
    emit(state.copyWith(status: HomeStatus.loading));
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final posts = MockPosts.getPosts(category: event.category);
    
    emit(state.copyWith(
      status: HomeStatus.loaded,
      posts: posts,
      selectedCategory: event.category,
      clearCategory: event.category == null,
    ));
  }

  void _onRefreshPosts(RefreshPosts event, Emitter<HomeState> emit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final posts = MockPosts.getPosts(category: state.selectedCategory);
    
    emit(state.copyWith(
      status: HomeStatus.loaded,
      posts: posts,
    ));
  }

  void _onLikePost(LikePost event, Emitter<HomeState> emit) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
      }
      return post;
    }).toList();
    
    emit(state.copyWith(posts: updatedPosts));
  }

  void _onSelectCategory(SelectCategory event, Emitter<HomeState> emit) {
    add(LoadPosts(category: event.category));
  }

  void _onSearchPosts(SearchPosts event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    final posts = MockPosts.getPosts(
      category: state.selectedCategory,
      searchQuery: event.query,
    );
    
    emit(state.copyWith(
      status: HomeStatus.loaded,
      posts: posts,
    ));
  }
}