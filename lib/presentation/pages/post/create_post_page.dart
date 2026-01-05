
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_social/presentation/controllers/post_controller.dart';

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (_selectedImage == null) {
      Get.snackbar('Error', 'Please select an image');
      return;
    }
    await _postController.createPost(
      _selectedImage!,
      _captionController.text.trim().isEmpty ? null : _captionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          Obx(() {
            if (_postController.isCreatingPost.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            }
            return IconButton(
              onPressed: _createPost,
              icon: const Icon(Icons.check),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap to select image',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Caption (optional)',
                border: OutlineInputBorder(),
                hintText: 'What\'s on your mind?',
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (_postController.error.value.isNotEmpty) {
                return Text(
                  _postController.error.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}