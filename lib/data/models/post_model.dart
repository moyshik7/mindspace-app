enum PostFlair {
  anxiety,
  gratitude,
  venting,
  adviceNeeded,
  personalGrowth,
  other,
}

extension PostFlairExtension on PostFlair {
  String get label {
    switch (this) {
      case PostFlair.anxiety:
        return 'Anxiety';
      case PostFlair.gratitude:
        return 'Gratitude';
      case PostFlair.venting:
        return 'Venting';
      case PostFlair.adviceNeeded:
        return 'Advice Needed';
      case PostFlair.personalGrowth:
        return 'Personal Growth';
      case PostFlair.other:
        return 'Other';
    }
  }
}

class PostModel {
  final String id;
  final String username;
  final PostFlair flair;
  final String text;
  final int likes;
  final int comments;
  final DateTime createdAt;
  bool isLiked;

  PostModel({
    required this.id,
    required this.username,
    required this.flair,
    required this.text,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.isLiked = false,
  });
}
