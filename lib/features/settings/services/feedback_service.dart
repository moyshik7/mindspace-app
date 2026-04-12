import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FeedbackService {
  static const String _url = 'https://www.mindspacebd.com/api/feedback';
  static const String _appVersion = '1.1.6+1';

  Future<void> sendFeedback({
    required String name,
    required String subject,
    required String message,
    String? email,
    String? phone,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-App-Version': _appVersion,
      'X-Platform': Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'other'),
    };

    final body = {
      'name': name,
      'subject': subject,
      'message': message,
      if (email != null && email.isNotEmpty) 'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'appVersion': _appVersion,
      'platform': Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'other'),
    };

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to send support request');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error. Please check your connection.');
      }
      rethrow;
    }
  }
}
