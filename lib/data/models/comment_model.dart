import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;
  final String? userPhotoUrl;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
    required this.userPhotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': timestamp,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  factory CommentModel.fromMap(String id, Map<String, dynamic> map) {
    return CommentModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      text: map['text'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}