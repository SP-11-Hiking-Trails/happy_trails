class TrailReview {
  final String id;
  final String trailId;
  final int rating;

  TrailReview({
    required this.id,
    required this.trailId,
    required this.rating,
  });

  factory TrailReview.fromJson(Map<String, dynamic> json) {
    return TrailReview(
      id: json['id'],
      trailId: json['trailId'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trailId': trailId,
      'rating': rating,
    };
  }
}