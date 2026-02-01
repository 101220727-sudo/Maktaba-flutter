class News {
  final int id;
  final String title;
  final String description;
  final String? image;
  final DateTime? publishedAt;

  News({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
    );
  }
}
