abstract class UserEntity {
  final String uid;
  final String displayName;
  final String? photoUrl;
  final String email;
  final DateTime createdAt;

  UserEntity({
    required this.uid, 
    required this.displayName, 
    this.photoUrl, 
    required this.email, 
    required this.createdAt
  });
}