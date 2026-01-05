
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_social/domain/entities/user_entity.dart';

abstract class AuthRepositoryInterface {
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserEntity?> getUser(String uid);
}