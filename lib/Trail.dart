import 'dart:math';
import 'package:amplify_flutter/amplify_flutter.dart';

class Trail extends Model {
  static const classType = const _TrailModelType();

  @override
  String getId() {
    return id;
  }

  final String id;
  final String name;
  final String description;
  final String location;
  final double trailRating;
  final int trailUsers;
  final List<String> imageURLs;
  final double avgRating;
  final int numRatings;

  Trail({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.trailRating,
    required this.trailUsers,
    required this.imageURLs,
    double? avgRating,
    int? numRatings,
  })  : avgRating = avgRating ?? (3.0 + Random().nextDouble() * 2.0) * 0,
        numRatings = numRatings ?? Random().nextInt(21)* 0; //remove these later. rands for testing

  Trail copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    double? trailRating,
    int? trailUsers,
    List<String>? imageURLs,
    double? avgRating,
    int? numRatings,
  }) {
    return Trail(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      trailRating: trailRating ?? this.trailRating,
      trailUsers: trailUsers ?? this.trailUsers,
      imageURLs: imageURLs ?? this.imageURLs,
      avgRating: avgRating ?? this.avgRating,
      numRatings: numRatings ?? this.numRatings,
    );
  }

  @override
  getInstanceType() => classType;

  @override
  String toString() {
    return 'Trail(id: $id, name: $name, description: $description, location: $location, trailRating: $trailRating, trailUsers: $trailUsers, imageURLs: $imageURLs, avgRating: $avgRating, numRatings: $numRatings)';
  }

  factory Trail.fromJson(Map<String, dynamic> json) {
    final List<String> imageURLs = [];
    if (json['images'] != null) {
      for (var image in json['images']) {
        imageURLs.add(image['url']);
      }
    }
    return Trail(
      id: json['id'] ?? '',
      name: json['fullName'],
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      trailRating: json['trailRating']?.toDouble() ?? 5.0,
      trailUsers: json['trailUsers']?.toInt() ?? 0,
      imageURLs: imageURLs,
    );
  }
}

class _TrailModelType extends ModelType<Trail> {
  const _TrailModelType();

  @override
  Trail fromJson(Map<String, dynamic> jsonData) {
    return Trail.fromJson(jsonData);
  }
}