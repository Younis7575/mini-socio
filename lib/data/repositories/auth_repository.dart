
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_social/data/models/user_model.dart';
import 'package:mini_social/data/services/firebase_auth_service.dart';
import 'package:mini_social/data/services/firestore_service.dart';
import 'package:mini_social/domain/entities/user_entity.dart';
import 'package:mini_social/domain/repositories/auth_repository_interface.dart';


class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    
    if (user != null) { 
      final existingUser = await _firestoreService.getUser(user.uid);
      
      if (existingUser == null) { 
        final newUser = UserModel(
          uid: user.uid,
          displayName: user.displayName ?? 'Anonymous',
          photoUrl: user.photoURL,
          email: user.email!,
          createdAt: DateTime.now(),
        );
        
        await _firestoreService.createUser(newUser);
        return newUser;  
      } else { 
        return existingUser;
      }
    }
    return null;
  }
  Future<void> updateUserDisplayName(String uid, String newName) async {
  await _firestoreService.updateUserData(uid, {'displayName': newName});
}

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Future<UserEntity?> getUser(String uid) async { 
    return await _firestoreService.getUser(uid);
  }
}

