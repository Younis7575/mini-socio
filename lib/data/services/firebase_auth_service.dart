 
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
       
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
 
      try {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } catch (e) { 
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