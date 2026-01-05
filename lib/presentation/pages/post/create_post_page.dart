 

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_social/app/theme/app_colors.dart';
import 'package:mini_social/app/theme/app_text_styles.dart'; 
import 'package:mini_social/app/theme/paints/paint_button.dart';
import 'package:mini_social/app/theme/paints/paint_card.dart';
import 'package:mini_social/app/theme/paints/paint_circle.dart';
import 'package:mini_social/app/theme/paints/paint_rectangle.dart';
import 'package:mini_social/app/theme/paints/paint_square.dart';
import 'package:mini_social/presentation/controllers/post_controller.dart';
import 'package:animate_do/animate_do.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final PostController _postController = Get.find();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedImage;
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _captionFocusNode = FocusNode();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (_selectedImage == null) {
      Get.snackbar(
        'Image Required',
        'Please select or take a photo to share',
        backgroundColor: CustomColors.error.withOpacity(0.9),
        colorText: CustomColors.primaryText,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    await _postController.createPost(
      _selectedImage!,
      _captionController.text.trim().isEmpty ? null : _captionController.text.trim(),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: CustomColors.shadow,
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: CustomColors.divider,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Image Source',
              style: CustomTextStyles.dialogTitle,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                  color: CustomColors.primaryAccent,
                ),
                _buildImageSourceButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                  color: CustomColors.secondaryAccent,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: PaintSquare(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: CustomColors.secondaryText,),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: CustomColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
    // Custom App Bar
SliverAppBar(
  expandedHeight: 120,
  floating: true,
  pinned: true,
  backgroundColor: CustomColors.primaryBackground, // Black
  flexibleSpace: FlexibleSpaceBar(
    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: CustomColors.feedGradient,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.3), // Dark overlay for better readability
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          child: FadeInDown(
            child: Text(
              'Create Post',
              style: CustomTextStyles.createPostTitle,
            ),
          ),
        ),
      ),
    ),
  ),
  actions: [
    Obx(() {
      if (_postController.isCreatingPost.value) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: CustomColors.primaryText),
        );
      }
      return FadeInRight(
        child: IconButton(
          onPressed: _createPost,
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomColors.overlayLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: CustomColors.primaryText),
          ),
        ),
      );
    }),
  ],
),


          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Image Selection Area
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: CustomPaint(
                          painter: PaintCard(),
                          child: Container(
                            width: double.infinity,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: _selectedImage != null
                                ? Stack(
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(23),
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      // Glass Overlay
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(23),
                                              bottomRight: Radius.circular(23),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                CustomColors.overlayDark,
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Change Image Button
                                      Positioned(
                                        bottom: 20,
                                        right: 20,
                                        child: GestureDetector(
                                          onTap: _showImageSourceDialog,
                                          child: CustomPaint(
                                            painter: PaintCircle(),
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(
                                                Icons.edit,
                                                color: CustomColors.primaryText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElasticIn(
                                        duration: const Duration(milliseconds: 1500),
                                        child: CustomPaint(
                                          painter: PaintCircle(),
                                          child: Container(
                                            padding: const EdgeInsets.all(30),
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              size: 60,
                                              color: CustomColors.iconPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Tap to add a photo',
                                        style: CustomTextStyles.createPostLabel,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Select from gallery or take a photo',
                                        style: CustomTextStyles.createPostHint,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Caption Input
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 200),
                        child: CustomPaint(
                          painter: PaintRectangle(),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomPaint(
                                      painter: PaintCircle(),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.edit_note,
                                          color: CustomColors.iconPrimary,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Add a caption',
                                      style: CustomTextStyles.createPostLabel,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _captionController,
                                  focusNode: _captionFocusNode,
                                  style: CustomTextStyles.inputText,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'What\'s on your mind? Share your thoughts...',
                                    hintStyle: CustomTextStyles.createPostHint,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(0),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Post Button
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Obx(() {
                          if (_postController.error.value.isNotEmpty) {
                            return SlideInLeft(
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CustomColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: CustomColors.error.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: CustomColors.error,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _postController.error.value,
                                        style: CustomTextStyles.errorMessage,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Pulse(
                            infinite: _selectedImage != null,
                            child: CustomPaint(
                              painter: PaintButton(),
                              child: Container(
                                width: 350,
                                height: 60,
                                child: GestureDetector(
                                  onTap: _createPost,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload, color: CustomColors.primaryText),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Upload Post',
                                        style: CustomTextStyles.createPostButton,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Preview Section
                      if (_selectedImage != null)
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: CustomPaint(
                            painter: PaintRectangle(),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Post Preview',
                                    style: CustomTextStyles.sectionHeader,
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  if (_captionController.text.isNotEmpty)
                                    Text(
                                      _captionController.text,
                                      style: TextStyle(
                                        color: CustomColors.secondaryText,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    _captionFocusNode.dispose();
    super.dispose();
  }
}