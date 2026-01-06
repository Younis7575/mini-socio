 
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_social/data/models/comment_model.dart';
import 'package:mini_social/presentation/controllers/auth_controller.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/repositories/post_repository.dart';

class PostController extends GetxController {
  final PostRepository _postRepository;
  final TextEditingController commentController = TextEditingController();
  AuthController get _authController => Get.find<AuthController>();

  PostController({required PostRepository postRepository})
      : _postRepository = postRepository;

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingPost = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;
   
  final RxBool isRefreshing = false.obs; 
  DocumentSnapshot? _lastDocument; 
  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit(); 
    _loadInitialPosts();
  }

  Future<void> refreshPosts() async {
    try {
      isRefreshing.value = true;
      _lastDocument = null;
      posts.clear();
      await _loadInitialPosts();
    } catch (e) {
      error.value = 'Failed to refresh: $e';
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> _loadInitialPosts() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      _postRepository.getPostsStream(limit: _pageSize).listen((postResult) {
        final postModels = postResult.posts.map((entity) {
          return PostModel(
            id: entity.id,
            userId: entity.userId,
            userDisplayName: entity.userDisplayName,
            userPhotoUrl: entity.userPhotoUrl,
            imageUrl: entity.imageUrl,
            caption: entity.caption,
            timestamp: entity.timestamp,
            likes: entity.likes,
            commentCount: entity.commentCount,
          );
        }).toList();
        
        posts.assignAll(postModels);
        _lastDocument = postResult.lastDocument;
        hasMore.value = postResult.hasMore;
      }, onError: (error) {
        this.error.value = 'Failed to load posts: $error';
      });
      
    } catch (e) {
      error.value = 'Failed to load posts: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore.value || !hasMore.value) return;
    
    try {
      isLoadingMore.value = true;
      
      final result = await _postRepository.getPostsStream(
        startAfter: _lastDocument,
        limit: _pageSize,
      ).first;
      
      if (result.posts.isNotEmpty) {
        final newPosts = result.posts.map((entity) {
          return PostModel(
            id: entity.id,
            userId: entity.userId,
            userDisplayName: entity.userDisplayName,
            userPhotoUrl: entity.userPhotoUrl,
            imageUrl: entity.imageUrl,
            caption: entity.caption,
            timestamp: entity.timestamp,
            likes: entity.likes,
            commentCount: entity.commentCount,
          );
        }).toList();
        
        posts.addAll(newPosts);
        _lastDocument = result.lastDocument;
        hasMore.value = result.hasMore;
      }
    } catch (e) {
      error.value = 'Failed to load more posts: $e';
    } finally {
      isLoadingMore.value = false;
    }
  }

  
  final RxList<CommentModel> currentPostComments = <CommentModel>[].obs;

  void loadComments(String postId) {
    currentPostComments.clear();
    
    _postRepository.getCommentsStream(postId).listen((comments) {
      currentPostComments.assignAll(comments);
    });
  }

  Future<void> submitComment(String postId) async {
    if (commentController.text.trim().isEmpty) return;

    try {
      final user = _authController.currentUser.value;
      if (user == null) return;

      final comment = CommentModel(
        id: '',
        userId: user.uid,
        userName: user.displayName,
        text: commentController.text.trim(),
        userPhotoUrl: user.photoUrl,
        timestamp: DateTime.now(),
      );

      await _postRepository.addComment(postId, comment);
      commentController.clear();
      Get.back();
      Get.snackbar('Success', 'Comment posted!');
    } catch (e) {
      Get.snackbar('Error', 'Could not post comment');
    }
  }

  Future<void> createPost(File image, String? caption) async {
    try {
      isCreatingPost.value = true;
      error.value = '';
      
      if (_authController.currentUser.value == null) {
        debugPrint("User null, waiting for Auth sync...");
        await Future.delayed(const Duration(seconds: 2));
      }

      final user = _authController.currentUser.value;
      
      if (user == null) {
        throw Exception('Session expired or still loading. Please try again in a moment.');
      }
      
      debugPrint("User authenticated as: ${user.uid}. Proceeding to upload...");

      await _postRepository.createPost(
        image: image,
        userId: user.uid,
        userDisplayName: user.displayName,
        userPhotoUrl: user.photoUrl,
        caption: caption,
      );
      
      Get.back();
      Get.snackbar('Success', 'Post created successfully');
    } catch (e) {
      debugPrint("CREATE POST FAILED: $e");
      error.value = 'Failed to create post: $e';
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isCreatingPost.value = false;
    }
  }

  Future<void> toggleLike(String postId) async {
    try {
      final user = _authController.currentUser.value;
      if (user == null) return;
      await _postRepository.likePost(postId, user.uid);
    } catch (e) {
      Get.snackbar('Error', 'Failed to like post');
    }
  }

  Future<void> deletePost(String postId, String imageUrl) async {
    try {
      isLoading.value = true;
      await _postRepository.deletePost(postId, imageUrl);
      Get.snackbar('Success', 'Post deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post');
    } finally {
      isLoading.value = false;
    }
  }

  bool canDeletePost(String userId) {
    final currentUser = _authController.currentUser.value;
    return currentUser?.uid == userId;
  }
}