 
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_social/app/theme/app_colors.dart';
import 'package:mini_social/app/theme/app_text_styles.dart';
import 'package:mini_social/app/theme/paints/paint_button.dart';
import 'package:mini_social/app/theme/paints/paint_square.dart'; 
import 'package:mini_social/presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: CustomColors.loginGradient,
          ),
        ),
        child: Stack(
          children: [
            // Background Animated Circles
            ..._buildAnimatedCircles(size),
            
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    ElasticIn(
                      duration: const Duration(milliseconds: 1500),
                      child: _buildLogo(),
                    ),
                    const SizedBox(height: 30),
                    
                    // Glassmorphism Card
                    SlideInUp(
                      duration: const Duration(milliseconds: 800),
                      child: _buildGlassCard(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedCircles(Size size) {
    return [
      Positioned(
        top: size.height * 0.1,
        left: size.width * 0.1,
        child: FadeIn(
          duration: const Duration(seconds: 2),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: CustomColors.glassGradient,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: size.height * 0.2,
        right: size.width * 0.1,
        child: FadeIn(
          duration: const Duration(seconds: 2),
          delay: const Duration(milliseconds: 500),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  CustomColors.secondaryAccent.withOpacity(0.15),
                  CustomColors.primaryAccent.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: CustomColors.glassGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.overlayLight,
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.people_alt_rounded,
        size: 80,
        color: CustomColors.primaryText,
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return CustomPaint(
      painter: PaintSquare(),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(30),
      child: Column(
          children: [
            // App Title with Gradient Text
            ShaderMask(
              shaderCallback: (bounds) => CustomTextStyles.whiteGradientShader,
              child: BounceInDown(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  'Mini Social',
                  style: CustomTextStyles.loginTitle,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Connect & Share Moments',
                style: CustomTextStyles.loginSubtitle,
              ),
            ),
            const SizedBox(height: 30),
            
            // Sign in Button
            _buildSignInButton(),
            const SizedBox(height: 20),
            
            // Error Message
            Obx(() {
              if (_authController.error.value.isNotEmpty) {
                return SlideInLeft(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: CustomColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: CustomColors.error.withOpacity(0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _authController.error.value,
                            style: CustomTextStyles.errorMessage.copyWith(
                              color: CustomColors.error.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
            
            // Loading Indicator
            Obx(() {
              if (_authController.isLoading.value) {
                return FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: CustomColors.glassGradient,
                            ),
                          ),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.primaryText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeIn(
                          delay: const Duration(milliseconds: 300),
                          child: Text(
                            'Signing you in...',
                            style: CustomTextStyles.loadingText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Pulse(
      infinite: true,
      duration: const Duration(seconds: 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: CustomColors.glassWhite(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColors.overlayLight,
              blurRadius: 10,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: CustomColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          onTap: _authController.signInWithGoogle,
          borderRadius: BorderRadius.circular(20),
          child: CustomPaint(
            painter: PaintButton(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 18,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(8), 
                      child: Image.asset(
                        'assets/images/search.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  FadeInRight(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Google',
                      style: CustomTextStyles.loginButton.copyWith(
                        color: CustomColors.iconPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}