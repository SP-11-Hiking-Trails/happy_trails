class Trail {
  final String name;
  final String description;
  final String location;
  final double trailRating;
  final int trailUsers;
  final List<String> imageURLs;

  Trail({
    required this.name,
    required this.description,
    required this.location,
    required this.trailRating,
    required this.trailUsers,
    required this.imageURLs,
  });

  factory Trail.fromJson(Map<String, dynamic> json) {
    final List<String> imageURLs = [];
    if (json['images'] != null) {
      for (var image in json['images']) {
        imageURLs.add(image['url']);
      }
    }
    return Trail(
      name: json['fullName'],
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      trailRating: json['trailRating']?.toDouble() ?? 5.0,
      trailUsers: json['trailUsers']?.toInt() ?? 0,
      imageURLs: imageURLs,
    );
  }
}