
class PostEntity {
  final String id;
  final String userId;
  final String userDisplayName;
  final String? userPhotoUrl;
  final String imageUrl;
  final String? caption;
  final DateTime timestamp;
  final List<String> likes;
  final int commentCount;

  PostEntity({
    required this.id,
    required this.userId,
    required this.userDisplayName,
    this.userPhotoUrl,
    required this.imageUrl,
    this.caption,
    required this.timestamp,
    required this.likes,
    required this.commentCount,
  });
}