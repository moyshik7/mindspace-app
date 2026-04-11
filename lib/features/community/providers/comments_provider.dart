import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../services/socket_service.dart';

class CommentsState {
  final List<CommentModel> comments;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String? error;

  CommentsState({
    required this.comments,
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  CommentsState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? error,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
    );
  }
}

class CommentsNotifier extends StateNotifier<CommentsState> {
  final String postId;
  final PostRepository _repository;
  final SocketService _socketService;
  StreamSubscription? _commentNewSub;
  StreamSubscription? _commentDeletedSub;
  StreamSubscription? _commentLikedSub;

  CommentsNotifier({
    required this.postId,
    required PostRepository repository,
    required SocketService socketService,
  })  : _repository = repository,
        _socketService = socketService,
        super(CommentsState(comments: [])) {
    _initSocketListeners();
    fetchComments();
  }

  void _initSocketListeners() {
    _socketService.joinPost(postId);

    _commentNewSub = _socketService.onCommentNew.listen((data) {
      if (data.containsKey('comment')) {
        final newComment = CommentModel.fromJson(data['comment']);
        if (!state.comments.any((c) => c.id == newComment.id)) {
          state = state.copyWith(comments: [newComment, ...state.comments]);
        }
      }
    });

    _commentDeletedSub = _socketService.onCommentDeleted.listen((data) {
      final commentId = data['commentId'];
      if (commentId != null) {
        state = state.copyWith(
          comments: state.comments.where((c) => c.id != commentId).toList(),
        );
      }
    });

    _commentLikedSub = _socketService.onCommentLiked.listen((data) {
      final commentId = data['commentId'];
      final likeCount = data['likeCount'];
      if (commentId != null && likeCount != null) {
        state = state.copyWith(
          comments: state.comments.map((c) {
            if (c.id == commentId) {
              return c.copyWith(likeCount: likeCount);
            }
            return c;
          }).toList(),
        );
      }
    });
  }

  Future<void> fetchComments({bool refresh = false}) async {
    if (state.isLoading || (!state.hasMore && !refresh)) return;

    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final newComments = await _repository.getComments(postId, page: state.page, limit: 20);
      state = state.copyWith(
        comments: refresh ? newComments : [...state.comments, ...newComments],
        isLoading: false,
        hasMore: newComments.length == 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addComment(String content, bool isAnonymous) async {
    try {
      final newComment = await _repository.createComment(postId, content, isAnonymous: isAnonymous);
      if (!state.comments.any((c) => c.id == newComment.id)) {
        state = state.copyWith(comments: [newComment, ...state.comments]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleLike(String commentId) async {
    List<CommentModel> previousComments = List.from(state.comments);
    state = state.copyWith(
      comments: state.comments.map((c) {
        if (c.id == commentId) {
          return c.copyWith(
            isLiked: !c.isLiked,
            likeCount: c.isLiked ? c.likeCount - 1 : c.likeCount + 1,
          );
        }
        return c;
      }).toList(),
    );

    try {
      final result = await _repository.toggleLike(commentId, 'comment');
      state = state.copyWith(
        comments: state.comments.map((c) {
          if (c.id == commentId) {
            return c.copyWith(
              isLiked: result['isLiked'],
              likeCount: result['likeCount'],
            );
          }
          return c;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(comments: previousComments);
    }
  }

  @override
  void dispose() {
    _socketService.leavePost(postId);
    _commentNewSub?.cancel();
    _commentDeletedSub?.cancel();
    _commentLikedSub?.cancel();
    super.dispose();
  }
}

final commentsNotifierProvider = StateNotifierProvider.family<CommentsNotifier, CommentsState, String>((ref, postId) {
  final repository = ref.watch(postRepositoryProvider);
  final socketService = ref.watch(socketServiceProvider);
  return CommentsNotifier(
    postId: postId,
    repository: repository,
    socketService: socketService,
  );
});
