import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_posts.dart';
import '../../../../data/models/post.dart';
import '../../../../data/repositories/firestore_post_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FirestorePostRepository? _repository;

  HomeBloc() : super(const HomeState()) {
    on<LoadPosts>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<LikePost>(_onLikePost);
    on<SelectCategory>(_onSelectCategory);
    on<SearchPosts>(_onSearchPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
  }

  FirestorePostRepository get _repo {
    _repository ??= FirestorePostRepository();
    return _repository!;
  }

  Future<List<Post>> _fetchPosts({PostCategory? category, String? searchQuery}) async {
    try {
      return await _repo.getPosts(category: category, searchQuery: searchQuery);
    } catch (e) {
      // Firestore 不可用时回退 mock 数据
      return MockPosts.getPosts(category: category, searchQuery: searchQuery);
    }
  }

  void _onLoadPosts(LoadPosts event, Emitter<HomeState> emit) async {
    if (state.status == HomeStatus.loading) return;
    
    emit(state.copyWith(status: HomeStatus.loading));
    
    final posts = await _fetchPosts(category: event.category);
    
    emit(state.copyWith(
      status: HomeStatus.loaded,
      posts: posts,
      selectedCategory: event.category,
      clearCategory: event.category == null,
    ));
  }

  void _onRefreshPosts(RefreshPosts event, Emitter<HomeState> emit) async {
    final posts = await _fetchPosts(category: state.selectedCategory);
    
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
    
    final posts = await _fetchPosts(
      category: state.selectedCategory,
      searchQuery: event.query,
    );
    
    emit(state.copyWith(
      status: HomeStatus.loaded,
      posts: posts,
    ));
  }

  void _onLoadMorePosts(LoadMorePosts event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    final posts = await _fetchPosts();
    
    emit(state.copyWith(
      status: HomeStatus.loaded,
      posts: posts,
      selectedCategory: null,
    ));
  }
}