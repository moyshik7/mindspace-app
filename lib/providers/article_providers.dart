import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/article_model.dart';
import '../services/article_service.dart';

final articlesProvider = FutureProvider<List<ArticleModel>>((ref) async {
  return ArticleService.fetchArticles();
});

final articleDetailProvider = FutureProvider.family<ArticleModel?, String>((ref, slug) async {
  return ArticleService.fetchArticleDetail(slug);
});
