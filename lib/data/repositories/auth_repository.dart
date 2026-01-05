
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
      // 1. Check if the user already exists in our Firestore database
      final existingUser = await _firestoreService.getUser(user.uid);
      
      if (existingUser == null) {
        // 2. If NEW user, create the model and SAVE to Firestore
        final newUser = UserModel(
          uid: user.uid,
          displayName: user.displayName ?? 'Anonymous',
          photoUrl: user.photoURL,
          email: user.email!,
          createdAt: DateTime.now(),
        );
        
        await _firestoreService.createUser(newUser);
        return newUser; // UserModel implements UserEntity
      } else {
        // 3. If EXISTING user, return the data we found in Firestore
        return existingUser;
      }
    }
    return null;
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
    // This returns UserModel which implements UserEntity
    return await _firestoreService.getUser(uid);
  }
}

// class AuthRepository implements AuthRepositoryInterface {
//   final FirebaseAuthService _authService;
//   final FirestoreService _firestoreService;

//   AuthRepository({
//     required FirebaseAuthService authService,
//     required FirestoreService firestoreService,
//   })  : _authService = authService,
//         _firestoreService = firestoreService;

// @override
// Future<UserEntity?> signInWithGoogle() async {
//   final user = await _authService.signInWithGoogle();
//   if (user != null) {
//     // ... your logic to check existing user in firestore ...
    
//     final userModel = UserModel(
//       uid: user.uid,
//       displayName: user.displayName ?? 'Anonymous',
//       photoUrl: user.photoURL,
//       email: user.email!,
//       createdAt: DateTime.now(),
//     );

//     // This will no longer throw an error because UserModel implements UserEntity
//     return userModel; 
//   }
//   return null;
// }

//   @override
//   Future<void> signOut() async {
//     await _authService.signOut();
//   }

//   @override
//   Stream<User?> get authStateChanges => _authService.authStateChanges;

//   @override
//   User? get currentUser => _authService.currentUser;
  
//   @override
//   Future<UserEntity?> getUser(String uid) async {
//     final userModel = await _firestoreService.getUser(uid);
//     return userModel as UserEntity?;
//   }
// }