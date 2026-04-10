class CommentModel {
  final String id;
  final String username;
  final String text;
  final DateTime createdAt;
  int likes;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.username,
    required this.text,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
  });
}
