import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  static const String baseUrl = 'https://api.bmchacks.app/api/v1';

  static Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requireAuth) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint, {bool requireAuth = false}) async {
    var headers = await _getHeaders(requireAuth: requireAuth);
    var response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    
    // Auto-refresh token if expired (401) and try once more
    if (response.statusCode == 401 && requireAuth) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken(true);
        headers['Authorization'] = 'Bearer $token';
        response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
      }
    }
    return response;
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool requireAuth = false}) async {
    var headers = await _getHeaders(requireAuth: requireAuth);
    var response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 401 && requireAuth) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken(true);
        headers['Authorization'] = 'Bearer $token';
        response = await http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers,
          body: jsonEncode(body),
        );
      }
    }
    return response;
  }

  static Future<http.Response> delete(String endpoint, {bool requireAuth = true}) async {
    var headers = await _getHeaders(requireAuth: requireAuth);
    var response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    
    if (response.statusCode == 401 && requireAuth) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken(true);
        headers['Authorization'] = 'Bearer $token';
        response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
      }
    }
    return response;
  }
}
