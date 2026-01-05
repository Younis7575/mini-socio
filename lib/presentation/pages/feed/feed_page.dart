
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:mini_social/data/models/post_model.dart';
// import 'package:mini_social/presentation/controllers/auth_controller.dart';
// import 'package:mini_social/presentation/controllers/post_controller.dart';

// class FeedPage extends StatelessWidget {
//   final PostController _postController = Get.find();
//   final AuthController _authController = Get.find();

//   FeedPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Feed'),
//         actions: [
//           IconButton(
//             onPressed: _authController.signOut,
//             icon: const Icon(Icons.logout),
//             tooltip: 'Sign out',
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.toNamed('/create-post'),
//         child: const Icon(Icons.add),
//       ),
//       body: Obx(() {
//         if (_postController.posts.isEmpty) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.photo_library, size: 80, color: Colors.grey),
//                 SizedBox(height: 20),
//                 Text(
//                   'No posts yet',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//                 Text(
//                   'Be the first to share a moment!',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: _postController.posts.length,
//           itemBuilder: (context, index) {
//             final post = _postController.posts[index];
//             return PostCard(post: post);
//           },
//         );
//       }),
//     );
//   }
// }

// class PostCard extends StatelessWidget {
//   final PostModel post;
//   final PostController _postController = Get.find();
//   final AuthController _authController = Get.find();

//   PostCard({super.key, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               backgroundImage: post.userPhotoUrl != null
//                   ? CachedNetworkImageProvider(post.userPhotoUrl!)
//                   : null,
//               child: post.userPhotoUrl == null
//                   ? Text(post.userDisplayName[0])
//                   : null,
//             ),
//             title: Text(
//               post.userDisplayName,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               DateFormat('MMM d, y • h:mm a').format(post.timestamp),
//             ),
//             trailing: _postController.canDeletePost(post.userId)
//                 ? IconButton(
//                     onPressed: () {
//                       Get.defaultDialog(
//                         title: 'Delete Post',
//                         content: const Text('Are you sure?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Get.back(),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               _postController.deletePost(post.id, post.imageUrl);
//                               Get.back();
//                             },
//                             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                     icon: const Icon(Icons.more_vert),
//                   )
//                 : null,
//           ),
//           AspectRatio(
//             aspectRatio: 1,
//             child: CachedNetworkImage(
//               imageUrl: post.imageUrl,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 color: Colors.grey[200],
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 color: Colors.grey[200],
//                 child: const Icon(Icons.error),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 IconButton(
//                   onPressed: () => _postController.toggleLike(post.id),
//                   icon: Icon(
//                     post.likes.contains(_authController.currentUser.value?.uid)
//                         ? Icons.favorite
//                         : Icons.favorite_border,
//                     color: post.likes.contains(_authController.currentUser.value?.uid)
//                         ? Colors.red
//                         : null,
//                   ),
//                 ),
//                 Text('${post.likes.length} likes'),
//                 const Spacer(),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.comment),
//                 ),
//                 Text('${post.commentCount} comments'),
//               ],
//             ),
//           ),
//           if (post.caption != null && post.caption!.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//               child: Text(post.caption!),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert'; // Required for base64Decode
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/presentation/controllers/auth_controller.dart';
import 'package:mini_social/presentation/controllers/post_controller.dart';

class FeedPage extends StatelessWidget {
  final PostController _postController = Get.find();
  final AuthController _authController = Get.find();

  FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            onPressed: _authController.signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create-post'),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (_postController.posts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'No posts yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  'Be the first to share a moment!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _postController.posts.length,
          itemBuilder: (context, index) {
            final post = _postController.posts[index];
            return PostCard(post: post);
          },
        );
      }),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.userPhotoUrl != null
                  ? CachedNetworkImageProvider(post.userPhotoUrl!)
                  : null,
              child: post.userPhotoUrl == null
                  ? Text(post.userDisplayName.isNotEmpty ? post.userDisplayName[0] : "?")
                  : null,
            ),
            title: Text(
              post.userDisplayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('MMM d, y • h:mm a').format(post.timestamp),
            ),
            trailing: _postController.canDeletePost(post.userId)
                ? IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Delete Post',
                        content: const Text('Are you sure?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _postController.deletePost(post.id, post.imageUrl);
                              Get.back();
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                : null,
          ),
          // UPDATED: Image.memory for Base64 Strings
          AspectRatio(
            aspectRatio: 1,
            child: Image.memory(
              base64Decode(post.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return frame != null
                    ? child
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _postController.toggleLike(post.id),
                  icon: Icon(
                    post.likes.contains(_authController.currentUser.value?.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.likes.contains(_authController.currentUser.value?.uid)
                        ? Colors.red
                        : null,
                  ),
                ),
                Text('${post.likes.length} likes'),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.comment),
                ),
                Text('${post.commentCount} comments'),
              ],
            ),
          ),
          if (post.caption != null && post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(post.caption!),
            ),
        ],
      ),
    );
  }
}