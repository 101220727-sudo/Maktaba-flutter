class EventPackage {
  final int id;
  final String title;
  final String description;
  final double? price; // allow null
  final String image;  // allow null
  final int eventTime;

  EventPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.eventTime,
  });

  factory EventPackage.fromJson(Map<String, dynamic> json) {
    return EventPackage(
      id: json['id'] ?? 0,
      title: json['package_title'] ?? '',
      description: json['description'] ?? '',
      price: json['total_price'] == null
          ? 0
          : (json['total_price'] as num).toDouble(),
      image: json['main_image'] ?? '',
      eventTime: json['event_time'] ?? 0,
    );
  }
}
