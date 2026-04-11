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

  static PostFlair fromString(String flairStr) {
    switch (flairStr) {
      case 'Anxiety':
        return PostFlair.anxiety;
      case 'Gratitude':
        return PostFlair.gratitude;
      case 'Venting':
        return PostFlair.venting;
      case 'Advice Needed':
        return PostFlair.adviceNeeded;
      case 'Personal Growth':
        return PostFlair.personalGrowth;
      default:
        return PostFlair.other;
    }
  }
}

class PostModel {
  final String id;
  final String authorUid;
  final String authorName;
  final String? authorPhoto;
  final PostFlair flair;
  final String content;
  final bool isAnonymous;
  late int likeCount;
  late int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isLiked;

  PostModel({
    required this.id,
    required this.authorUid,
    required this.authorName,
    this.authorPhoto,
    required this.flair,
    required this.content,
    required this.isAnonymous,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? '',
      authorUid: json['authorUid'] ?? '',
      authorName: json['authorName'] ?? 'Anonymous',
      authorPhoto: json['authorPhoto'],
      flair: PostFlairExtension.fromString(json['flair'] ?? 'Other'),
      content: json['content'] ?? '',
      isAnonymous: json['isAnonymous'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isLiked: json['isLiked'] ?? false,
    );
  }

  PostModel copyWith({
    String? id,
    String? authorUid,
    String? authorName,
    String? authorPhoto,
    PostFlair? flair,
    String? content,
    bool? isAnonymous,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorUid: authorUid ?? this.authorUid,
      authorName: authorName ?? this.authorName,
      authorPhoto: authorPhoto ?? this.authorPhoto,
      flair: flair ?? this.flair,
      content: content ?? this.content,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
