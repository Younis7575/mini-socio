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
          if (Get.currentRoute != '/feed') {
             debugPrint("Redirecting to Feed Page...");
             Get.offAllNamed('/feed');
          }
        }
      } else {
        currentUser.value = null;
        debugPrint("User signed out."); 
        if (Get.currentRoute != '/login') {
          Get.offAllNamed('/login');
        }
      }
    });
  }
  
Future<void> updateDisplayName(String newName) async {
  try {
    if (newName.trim().isEmpty) return;
    isLoading.value = true;

    final user = currentUser.value;
    if (user != null) { 
      await _authRepository.updateUserDisplayName(user.uid, newName); 
      currentUser.value = UserModel(
        uid: user.uid,
        displayName: newName,
        photoUrl: user.photoUrl,
        email: user.email,
        createdAt: user.createdAt,
      );
      
      Get.snackbar('Success', 'Display name updated successfully');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to update name: $e');
  } finally {
    isLoading.value = false;
  }
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
      currentUser.value = null; 
      debugPrint("Sign out successful");
    } catch (e) {
      debugPrint("Sign out error: $e");
      error.value = 'Sign out failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}