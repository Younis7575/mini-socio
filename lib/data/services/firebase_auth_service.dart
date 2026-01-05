// lib/data/services/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: '796467449596-dbblts65kkbi89f85aa0cargas2rluj0.apps.googleusercontent.com',
    serverClientId: '796467449596-dbblts65kkbi89f85aa0cargas2rluj0.apps.googleusercontent.com',
  );

  Future<User?> signInWithGoogle() async {
    try {
      if (kDebugMode) print('--- STARTING GOOGLE SIGN-IN ---');
      
      // 1. Sign out of Google first to force account selection and clear cache
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 2. Defensive Sign-In
      // We wrap this in a specific try-block because the Pigeon error 
      // happens during the RETURN of this function, even if the login worked.
      try {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } catch (e) {
        // If we see the Pigeon/Type error, it means the login worked but 
        // the response failed to parse. We return the currentUser instead.
        if (e.toString().contains('PigeonUserDetails') || e is TypeError) {
          if (kDebugMode) print('Handled Pigeon internal cast error. Fetching user from instance.');
          return _auth.currentUser;
        }
        rethrow;
      }
      
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('!!!!!!!! GOOGLE SIGN-IN ERROR !!!!!!!!');
        print('ERROR DETAILS: $e');
        print('STACK TRACE: $stackTrace');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) print('Sign-Out Error: $e');
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}