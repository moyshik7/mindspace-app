import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../services/socket_service.dart';

class CommunityState {
  final List<PostModel> posts;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String? error;

  CommunityState({
    required this.posts,
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  CommunityState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? error,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  final PostRepository _repository;
  final SocketService _socketService;
  StreamSubscription? _postNewSub;
  StreamSubscription? _postDeletedSub;
  StreamSubscription? _postLikedSub;

  CommunityNotifier(this._repository, this._socketService) : super(CommunityState(posts: [])) {
    _initSocketListeners();
    fetchPosts();
  }

  void _initSocketListeners() {
    _socketService.connect();
    
    _postNewSub = _socketService.onPostNew.listen((data) {
      if (data.containsKey('post')) {
        final newPost = PostModel.fromJson(data['post']);
        if (!state.posts.any((p) => p.id == newPost.id)) {
          state = state.copyWith(posts: [newPost, ...state.posts]);
        }
      }
    });

    _postDeletedSub = _socketService.onPostDeleted.listen((data) {
      final postId = data['postId'];
      if (postId != null) {
        state = state.copyWith(
          posts: state.posts.where((p) => p.id != postId).toList(),
        );
      }
    });

    _postLikedSub = _socketService.onPostLiked.listen((data) {
      final postId = data['postId'];
      final likeCount = data['likeCount'];
      final bool isLiked = data['isLiked'] ?? false;
      if (postId != null && likeCount != null) {
        state = state.copyWith(
          posts: state.posts.map((p) {
            if (p.id == postId) {
              return p.copyWith(likeCount: likeCount, isLiked: (p.isLiked) ? true : isLiked);
            }
            return p;
          }).toList(),
        );
      }
    });
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (state.isLoading || (!state.hasMore && !refresh)) return;

    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final newPosts = await _repository.getPosts(page: state.page, limit: 20);
      state = state.copyWith(
        posts: refresh ? newPosts : [...state.posts, ...newPosts],
        isLoading: false,
        hasMore: newPosts.length == 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleLike(String postId) async {
    List<PostModel> previousPosts = List.from(state.posts);
    state = state.copyWith(
      posts: state.posts.map((p) {
        if (p.id == postId) {
          return p.copyWith(
            isLiked: !p.isLiked,
            likeCount: p.isLiked ? p.likeCount - 1 : p.likeCount + 1,
          );
        }
        return p;
      }).toList(),
    );

    try {
      final result = await _repository.toggleLike(postId, 'post');
      state = state.copyWith(
        posts: state.posts.map((p) {
          if (p.id == postId) {
            return p.copyWith(
              isLiked: result['isLiked'],
              likeCount: result['likeCount'],
            );
          }
          return p;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(posts: previousPosts);
    }
  }

  Future<void> deletePost(String postId) async {
    final previousPosts = List<PostModel>.from(state.posts);
    state = state.copyWith(
      posts: state.posts.where((p) => p.id != postId).toList(),
    );

    try {
      await _repository.deletePost(postId);
    } catch (e) {
      state = state.copyWith(posts: previousPosts, error: e.toString());
    }
  }

  @override
  void dispose() {
    _postNewSub?.cancel();
    _postDeletedSub?.cancel();
    _postLikedSub?.cancel();
    // Do not disconnect globally if other parts of the app rely on it, but here we can clean up if desired
    super.dispose();
  }
}

final communityNotifierProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  final socketService = ref.watch(socketServiceProvider);
  return CommunityNotifier(repository, socketService);
});
