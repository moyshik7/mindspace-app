class AiMessage {
  final String from; // 'user' or 'ai'
  final String message;
  final int id;
  final DateTime timestamp;

  AiMessage({
    required this.from,
    required this.message,
    required this.id,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'message': message,
      'id': id,
    };
  }

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      from: json['from'] as String,
      message: json['message'] as String,
      id: json['id'] as int,
    );
  }
}
