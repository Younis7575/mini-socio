import 'package:get/get.dart';
import 'package:mini_social/data/repositories/auth_repository.dart';
import 'package:mini_social/data/repositories/post_repository.dart';
import 'package:mini_social/data/services/firebase_auth_service.dart';
import 'package:mini_social/data/services/firestore_service.dart';
import 'package:mini_social/presentation/controllers/auth_controller.dart';
import 'package:mini_social/presentation/controllers/post_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() { 
    Get.lazyPut(() => FirebaseAuthService(), fenix: true);
    Get.lazyPut(() => FirestoreService(), fenix: true);
     
    Get.lazyPut(() => AuthRepository(
      authService: Get.find<FirebaseAuthService>(),
      firestoreService: Get.find<FirestoreService>(),
    ), fenix: true);
 
    Get.lazyPut(() => PostRepository(
      firestoreService: Get.find<FirestoreService>(),
    ), fenix: true);
 
    Get.put(
      AuthController(authRepository: Get.find<AuthRepository>()),
      permanent: true,
    );

    Get.lazyPut(() => PostController(
      postRepository: Get.find<PostRepository>(),
    ), fenix: true);
  }
}