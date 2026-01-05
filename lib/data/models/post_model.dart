// lib/data/models/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userDisplayName;
  final String? userPhotoUrl;
  final String imageUrl;
  final String? caption;
  final DateTime timestamp;
  final List<String> likes;
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