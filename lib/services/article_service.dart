import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/article_model.dart';

class ArticleService {
  static const String _baseUrl = 'https://www.mindspacebd.com/api/articles';
  static const String _cacheKeyList = 'cached_articles_list';
  static const String _cacheKeyPrefix = 'cached_article_';

  static Future<List<ArticleModel>> fetchArticles() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Try to load from cache first
    final cachedData = prefs.getString(_cacheKeyList);
    List<ArticleModel> cachedList = [];
    if (cachedData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedData);
        cachedList = decoded.map((e) => ArticleModel.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error decoding cached articles: $e');
      }
    }

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json['success'] == true) {
          final List<dynamic> data = json['data'];
          final articles = data.map((e) => ArticleModel.fromJson(e)).toList();
          
          // Update cache
          await prefs.setString(_cacheKeyList, jsonEncode(data));
          return articles;
        }
      }
    } catch (e) {
      debugPrint('Error fetching articles: $e');
    }

    return cachedList;
  }

  static Future<ArticleModel?> fetchArticleDetail(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cacheKeyPrefix$slug';

    // Try cache
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        return ArticleModel.fromJson(jsonDecode(cachedData));
      } catch (e) {
        debugPrint('Error decoding cached article $slug: $e');
      }
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/$slug'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json['success'] == true) {
          final data = json['data'];
          final article = ArticleModel.fromJson(data);
          
          // Update cache
          await prefs.setString(cacheKey, jsonEncode(data));
          return article;
        }
      }
    } catch (e) {
      debugPrint('Error fetching article $slug: $e');
    }

    return null;
  }
}
