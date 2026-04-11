import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

class PostRepository {
  Future<List<PostModel>> getPosts({int page = 1, int limit = 20, String sort = 'newest', String? flair}) async {
    String endpoint = '/posts?page=$page&limit=$limit&sort=$sort';
    if (flair != null && flair.isNotEmpty) {
      endpoint += '&flair=$flair';
    }
    
    final response = await ApiClient.get(endpoint, requireAuth: false);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data']['posts'];
      return data.map((e) => PostModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load posts');
  }

  Future<PostModel> createPost({
    required String content,
    required String flair,
    bool isAnonymous = false,
  }) async {
    final response = await ApiClient.post('/posts', {
      'content': content,
      'flair': flair,
      'isAnonymous': isAnonymous,
    }, requireAuth: true);

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return PostModel.fromJson(json['data']['post']);
    }
    throw Exception('Failed to create post');
  }

  Future<void> deletePost(String postId) async {
    final response = await ApiClient.delete('/posts/$postId', requireAuth: true);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }

  Future<void> reportPost(String postId) async {
    final response = await ApiClient.post('/posts/$postId/report', {}, requireAuth: true);
    if (response.statusCode != 200) {
      throw Exception('Failed to report post');
    }
  }

  Future<List<CommentModel>> getComments(String postId, {int page = 1, int limit = 20}) async {
    final response = await ApiClient.get('/posts/$postId/comments?page=$page&limit=$limit', requireAuth: false);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data']['comments'];
      return data.map((e) => CommentModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load comments');
  }

  Future<CommentModel> createComment(String postId, String content, {bool isAnonymous = false}) async {
    final response = await ApiClient.post('/posts/$postId/comments', {
      'content': content,
      'isAnonymous': isAnonymous,
    }, requireAuth: true);

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return CommentModel.fromJson(json['data']['comment']);
    }
    throw Exception('Failed to create comment');
  }

  Future<void> deleteComment(String postId, String commentId) async {
    final response = await ApiClient.delete('/posts/$postId/comments/$commentId', requireAuth: true);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }

  Future<void> reportComment(String postId, String commentId) async {
    final response = await ApiClient.post('/posts/$postId/comments/$commentId/report', {}, requireAuth: true);
    if (response.statusCode != 200) {
      throw Exception('Failed to report comment');
    }
  }

  Future<Map<String, dynamic>> toggleLike(String targetId, String targetType) async {
    final response = await ApiClient.post('/likes', {
      'targetId': targetId,
      'targetType': targetType,
    }, requireAuth: true);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    }
    throw Exception('Failed to like');
  }
}
