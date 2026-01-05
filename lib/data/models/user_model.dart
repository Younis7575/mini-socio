
import 'package:mini_social/domain/entities/user_entity.dart';

class UserModel implements UserEntity {
  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String? photoUrl;
  @override
  final String email;
  @override
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    required this.email,
    required this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}