 
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_social/app/theme/app_colors.dart';
import 'package:mini_social/app/theme/app_text_styles.dart';
import 'package:mini_social/app/theme/paints/paint_square.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/presentation/controllers/auth_controller.dart';
import 'package:mini_social/presentation/controllers/post_controller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mini_social/presentation/pages/post/post_detail_page.dart';
import 'package:mini_social/presentation/pages/profile/profile_page.dart';

 

class FeedPage extends StatelessWidget {
  final PostController _postController = Get.find();
  final AuthController _authController = Get.find();
  final ScrollController _scrollController = ScrollController();

  FeedPage({super.key}) {
    // Setup scroll listener for infinite scroll
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when 200px from bottom
      _postController.loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      body: RefreshIndicator(
        onRefresh: () => _postController.refreshPosts(),
        backgroundColor: CustomColors.primaryBackground,
        color: CustomColors.primaryAccent,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              floating: true,
              pinned: true,
              backgroundColor: CustomColors.primaryBackground,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    debugPrint("Navigating to Profile...");
                    Get.to(() => ProfilePage());
                  },
                ),
                IconButton(
                  onPressed: () => _authController.signOut(),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Sign out',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(255, 19, 19, 20),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/images/pattern.jpg'),
                              fit: BoxFit.cover,
                              opacity: 0.1,
                            ),
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 60,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(
                              duration: const Duration(milliseconds: 800),
                              child: const Text(
                                'Social Feed',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeInDown(
                              duration: const Duration(milliseconds: 1000),
                              delay: const Duration(milliseconds: 200),
                              child: const Text(
                                'Share your moments with friends',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFB0B0B0),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Color.fromRGBO(
                                      255,
                                      255,
                                      255,
                                      0.1,
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color(0xFF444444),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () => Get.toNamed('/create-post'),
                                        child: Text(
                                          "What's on your mind?",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color(
                                              0xFFB0B0B0,
                                            ).withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              if (_postController.isLoading.value && _postController.posts.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (_postController.posts.isEmpty) {
                return SliverFillRemaining(
                  child: FadeIn(
                    duration: const Duration(milliseconds: 800),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElasticIn(
                            duration: const Duration(milliseconds: 1500),
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    CustomColors.primaryAccent.withOpacity(0.3),
                                    CustomColors.secondaryAccent.withOpacity(0.3),
                                ],
                                ),
                              ),
                              child: Icon(
                                Icons.photo_library_outlined,
                                size: 70,
                                color: CustomColors.primaryAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'No posts yet',
                            style: CustomTextStyles.emptyStateTitle,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Be the first to share a moment!',
                            style: CustomTextStyles.emptyStateSubtitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < _postController.posts.length) {
                    final post = _postController.posts[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: Duration(milliseconds: index * 100),
                      child: PostCard(post: post),
                    );
                  } else if (_postController.hasMore.value) { 
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.primaryAccent,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // End of list
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No more posts',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }
                }, childCount: _postController.posts.length + 
                    (_postController.hasMore.value ? 1 : 1)),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Bounce(
        duration: const Duration(seconds: 2),
        infinite: true,
        child: FloatingActionButton.extended(
          onPressed: () => Get.toNamed('/create-post'),
          backgroundColor: CustomColors.cardBackground,
          icon: Icon(Icons.add, size: 28, color: CustomColors.iconPrimary),
          label: Text(
            'Create Post',
            style: CustomTextStyles.buttonPrimary.copyWith(
              color: CustomColors.iconPrimary,
            ),
          ),
        ),
      ),
    );
  }

  
}
 
class PostCard extends StatelessWidget {
  final PostModel post;
  final PostController _postController = Get.find();
  final AuthController _authController = Get.find();

  PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPaint(
        painter: PaintSquare(),
        child: Container(
          margin: const EdgeInsets.all(12).copyWith(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: CustomColors.primaryAccent.withOpacity(
                        0.2,
                      ),
                      backgroundImage: post.userPhotoUrl != null
                          ? CachedNetworkImageProvider(post.userPhotoUrl!)
                          : null,
                      child: post.userPhotoUrl == null
                          ? Text(
                              post.userDisplayName[0].toUpperCase(),
                              style: TextStyle(
                                color: CustomColors.primaryAccent,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.userDisplayName,
                            style: CustomTextStyles.postUsername,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d • h:mm a').format(post.timestamp),
                            style: CustomTextStyles.postTimestamp,
                          ),
                        ],
                      ),
                    ),
                    if (_postController.canDeletePost(post.userId))
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () =>
                            _postController.deletePost(post.id, post.imageUrl),
                      ),
                  ],
                ),
              ),
              if (post.caption != null && post.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    post.caption!,
                    style: CustomTextStyles.postCaption,
                  ),
                ),
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                  child: Image.memory(
                    base64Decode(post.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Like Action
                    IconButton(
                      icon: Icon(
                        post.likes.contains(
                              _authController.currentUser.value?.uid,
                            )
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            post.likes.contains(
                              _authController.currentUser.value?.uid,
                            )
                            ? Colors.red
                            : Colors.white70,
                      ),
                      onPressed: () => _postController.toggleLike(post.id),
                    ),
                    Text(
                      '${post.likes.length}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    // Comment Action - Navigates to PostDetailPage
                    IconButton(
                      icon: const Icon(
                        Icons.comment_outlined,
                        color: Colors.white70,
                      ),
                      onPressed: () => Get.to(() => PostDetailPage(post: post)),
                    ),
                    Text(
                      '${post.commentCount}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
