// lib/data/models/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_social/domain/entities/post_entity.dart';

class PostModel implements PostEntity {
  @override
  final String id;
  @override
  final String userId;
  @override
  final String userDisplayName;
  @override
  final String? userPhotoUrl;
  @override
  final String imageUrl;
  @override
  final String? caption;
  @override
  final DateTime timestamp;
  @override
  final List<String> likes;
  @override
  final int commentCount;

  PostModel({
    required this.id,
    required this.userId,
    required this.userDisplayName,
    this.userPhotoUrl,
    required this.imageUrl,
    this.caption,
    required this.timestamp,
    List<String>? likes,
    this.commentCount = 0,
  }) : likes = likes ?? [];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userDisplayName': userDisplayName,
      'userPhotoUrl': userPhotoUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      // Sending FieldValue.serverTimestamp() is better for database accuracy
      'timestamp': timestamp, 
      'likes': likes,
      'commentCount': commentCount,
    };
  }

  factory PostModel.fromMap(String id, Map<String, dynamic> map) {
    // Handle both ISO Strings and Firestore Timestamps
    DateTime parsedTime;
    if (map['timestamp'] is Timestamp) {
      parsedTime = (map['timestamp'] as Timestamp).toDate();
    } else {
      parsedTime = DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now();
    }

    return PostModel(
      id: id,
      userId: map['userId'] ?? '',
      userDisplayName: map['userDisplayName'] ?? 'Anonymous',
      userPhotoUrl: map['userPhotoUrl'],
      imageUrl: map['imageUrl'] ?? '',
      caption: map['caption'],
      timestamp: parsedTime,
      likes: List<String>.from(map['likes'] ?? []),
      commentCount: map['commentCount'] ?? 0,
    );
  }
}