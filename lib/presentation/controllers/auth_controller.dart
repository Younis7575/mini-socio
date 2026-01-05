import 'package:get/get.dart';
import 'package:mini_social/data/repositories/auth_repository.dart';
import 'package:mini_social/data/models/user_model.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("Auth controller initialized");
    _setupAuthListener();
  }

void _setupAuthListener() {
    _authRepository.authStateChanges.listen((firebaseUser) async {
      debugPrint("Auth State Changed: ${firebaseUser?.email ?? 'No user'}");
      
      if (firebaseUser != null) {
        // Fetch the user data from Firestore
        final userEntity = await _authRepository.getUser(firebaseUser.uid);
        
        if (userEntity != null) {
          final userModel = UserModel(
            uid: userEntity.uid,
            displayName: userEntity.displayName,
            photoUrl: userEntity.photoUrl,
            email: userEntity.email,
            createdAt: userEntity.createdAt,
          );
          
          currentUser.value = userModel;
          debugPrint("User data synced to AuthController: ${userModel.displayName}");
          
          // FIX: Instead of checking if we are on '/login', we force move to '/feed'
          // This ensures that even if GetX thinks the route name is different, the app moves.
          if (Get.currentRoute != '/feed') {
             debugPrint("Redirecting to Feed Page...");
             Get.offAllNamed('/feed');
          }
        }
      } else {
        currentUser.value = null;
        debugPrint("User signed out.");
        // Only redirect to login if we aren't already there
        if (Get.currentRoute != '/login') {
          Get.offAllNamed('/login');
        }
      }
    });
  }
 

Future<void> signInWithGoogle() async {
  try {
    isLoading.value = true;
    final userEntity = await _authRepository.signInWithGoogle();
    
    if (userEntity != null) {
      currentUser.value = UserModel(
        uid: userEntity.uid,
        displayName: userEntity.displayName,
        photoUrl: userEntity.photoUrl,
        email: userEntity.email,
        createdAt: userEntity.createdAt,
      );
      
      debugPrint("Manual login successful. Forcing navigation to feed...");
      // DO NOT wait for the listener here, navigate immediately
      Get.offAllNamed('/feed'); 
    }
  } catch (e) {
    debugPrint("Login error: $e");
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authRepository.signOut();
      currentUser.value = null; // Immediate local update
      debugPrint("Sign out successful");
    } catch (e) {
      debugPrint("Sign out error: $e");
      error.value = 'Sign out failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}