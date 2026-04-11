class CommentModel {
  final String id;
  final String postId;
  final String authorUid;
  final String authorName;
  final String? authorPhoto;
  final String content;
  final bool isAnonymous;
  late int likeCount;
  final DateTime createdAt;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.postId,
    required this.authorUid,
    required this.authorName,
    this.authorPhoto,
    required this.content,
    required this.isAnonymous,
    this.likeCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      postId: json['postId'] ?? '',
      authorUid: json['authorUid'] ?? '',
      authorName: json['authorName'] ?? 'Anonymous',
      authorPhoto: json['authorPhoto'],
      content: json['content'] ?? '',
      isAnonymous: json['isAnonymous'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isLiked: json['isLiked'] ?? false,
    );
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? authorUid,
    String? authorName,
    String? authorPhoto,
    String? content,
    bool? isAnonymous,
    int? likeCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorUid: authorUid ?? this.authorUid,
      authorName: authorName ?? this.authorName,
      authorPhoto: authorPhoto ?? this.authorPhoto,
      content: content ?? this.content,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
