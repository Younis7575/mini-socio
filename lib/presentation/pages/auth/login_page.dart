
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_social/presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 40),
              const Text(
                'Mini Social App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to share moments with friends',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Obx(() {
                if (_authController.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton.icon(
                  onPressed: _authController.signInWithGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                );
              }),
              Obx(() {
                if (_authController.error.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _authController.error.value,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}