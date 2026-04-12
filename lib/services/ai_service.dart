import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/network/api_client.dart';
import '../data/models/ai_message_model.dart';

class AiService {
  static Future<String?> getAiResponse(String prompt, List<AiMessage> history) async {
    try {
      debugPrint('AI_SERVICE: Sending request with prompt: $prompt');
      debugPrint('AI_SERVICE: History count: ${history.length}');
      
      final response = await ApiClient.post(
        '/ai',
        {
          'prompt': prompt,
          'previousMessages': history.map((m) => m.toJson()).toList(),
        },
        requireAuth: true,
      );

      debugPrint('AI_SERVICE: Response status code: ${response.statusCode}');
      debugPrint('AI_SERVICE: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data']['response'] as String;
        }
      } else if (response.statusCode == 429) {
        return "QUOTA_EXCEEDED";
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Unknown error';
        return "ERROR: [$message] (Status: ${response.statusCode})";
      }
      return null;
    } catch (e, stack) {
      debugPrint('AI_SERVICE_EXCEPTION: $e');
      debugPrint('AI_SERVICE_STACK: $stack');
      return "ERROR: Exception: $e";
    }
  }
}
