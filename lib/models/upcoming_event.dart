class UpcomingEvent {
  final int id;
  final String title;
  final String description1;
  final String? description2;
  final String createdAt;

  UpcomingEvent({
    required this.id,
    required this.title,
    required this.description1,
    this.description2,
    required this.createdAt,
  });

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    return UpcomingEvent(
      id: json['id'],
      title: json['title'],
      description1: json['description1'],
      description2: json['description2'],
      createdAt: json['created_at'],
    );
  }
}
