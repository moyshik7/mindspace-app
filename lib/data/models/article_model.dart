class ArticleModel {
  final String slug;
  final String title;
  final String description;
  final String date;
  final String image;
  final List<String> keywords;
  final String readingTime;
  final String? content;

  ArticleModel({
    required this.slug,
    required this.title,
    required this.description,
    required this.date,
    required this.image,
    required this.keywords,
    required this.readingTime,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      image: json['image'] as String,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      readingTime: json['readingTime'] as String? ?? '5 min read',
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'description': description,
      'date': date,
      'image': image,
      'keywords': keywords,
      'readingTime': readingTime,
      'content': content,
    };
  }
}
