import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_social/app/theme/app_colors.dart';
import 'package:mini_social/app/theme/app_text_styles.dart';
import 'package:mini_social/app/theme/paints/paint_rectangle.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/presentation/controllers/post_controller.dart';

import 'package:mini_social/presentation/pages/feed/feed_page.dart';

class PostDetailPage extends StatelessWidget {
  final PostModel post;
  final PostController _controller = Get.find();

  PostDetailPage({super.key, required this.post}) {
    _controller.loadComments(post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: CustomColors.cardBackground,
        elevation: 0,
        title: Text('Post Details', style: CustomTextStyles.appBarTitle),
        centerTitle: true,
        iconTheme: const IconThemeData(color: CustomColors.primaryText),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostCard(post: post),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Comments',
                      style: CustomTextStyles.sectionHeader,
                    ),
                  ),

                  Divider(color: CustomColors.divider, thickness: 1),

                  Obx(() {
                    if (_controller.currentPostComments.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'No comments yet. Be the first to reply!',
                            style: TextStyle(color: CustomColors.hintText),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.currentPostComments.length,
                      itemBuilder: (context, index) {
                        final comment = _controller.currentPostComments[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomPaint(
                            painter: PaintRectangle(),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),

                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: CustomColors.primaryAccent
                                      .withOpacity(0.2),
                                  backgroundImage: comment.userPhotoUrl != null
                                      ? CachedNetworkImageProvider(
                                          comment.userPhotoUrl!,
                                        )
                                      : null,
                                  child: comment.userPhotoUrl == null
                                      ? Text(
                                          post.userDisplayName.isNotEmpty
                                              ? post.userDisplayName[0]
                                                    .toUpperCase()
                                              : "?",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.iconPrimary,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  comment.userName.toString(),
                                  style: CustomTextStyles.commentUsername
                                      .copyWith(
                                        color: CustomColors.iconPrimary,
                                      ),
                                ),
                                subtitle: Text(
                                  comment.text,
                                  style: CustomTextStyles.commentText,
                                ),
                                trailing: Text(
                                  DateFormat(
                                    'h:mm a',
                                  ).format(comment.timestamp),
                                  style: CustomTextStyles.commentTimestamp,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ), 

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: CustomColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: CustomColors.shadow,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: CustomColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: CustomColors.border,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controller.commentController,
                        style: CustomTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: CustomTextStyles.inputHint,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), 
                  CircleAvatar(
                    backgroundColor: CustomColors.primaryButton,
                    radius: 22,
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: CustomColors.primaryText,
                        size: 20,
                      ),
                      onPressed: () => _controller.submitComment(post.id),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
