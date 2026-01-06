import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_social/data/models/comment_model.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'createdAt': Timestamp.fromDate(
          user.createdAt,
        ), // Ensure it's always Timestamp
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;

      DateTime createdAt;
      final createdAtField = data['createdAt'];

      if (createdAtField is Timestamp) {
        createdAt = createdAtField.toDate();
      } else if (createdAtField is String) {
        try {
          createdAt = DateTime.parse(createdAtField);
        } catch (e) {
          createdAt = DateTime.now();
        }
      } else {
        createdAt = DateTime.now();
      }

      return UserModel(
        uid: data['uid'] ?? uid,
        displayName: data['displayName'] ?? 'Anonymous',
        photoUrl: data['photoUrl'],
        email: data['email'] ?? '',
        createdAt: createdAt,
      );
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<String> createPost(PostModel post) async {
    try {
      final docRef = _firestore.collection('posts').doc();
      final postData = {
        'id': docRef.id,
        'userId': post.userId,
        'userDisplayName': post.userDisplayName,
        'userPhotoUrl': post.userPhotoUrl,
        'imageUrl': post.imageUrl,
        'caption': post.caption,
        'timestamp': Timestamp.fromDate(post.timestamp),
        'likes': post.likes,
        'commentCount': post.commentCount,
      };

      await docRef.set(postData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Stream<List<PostModel>> getPostsStream({
    DocumentSnapshot? startAfter,
    int limit = 10,
  }) {
    var query = _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PostModel(
          id: data['id'] ?? doc.id,
          userId: data['userId'],
          userDisplayName: data['userDisplayName'],
          userPhotoUrl: data['userPhotoUrl'],
          imageUrl: data['imageUrl'],
          caption: data['caption'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          likes: List<String>.from(data['likes'] ?? []),
          commentCount: data['commentCount'] ?? 0,
        );
      }).toList();
    });
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(postRef);

        if (!doc.exists) {
          throw Exception('Post not found');
        }

        final data = doc.data()!;
        final likes = List<String>.from(data['likes'] ?? []);

        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }

        transaction.update(postRef, {'likes': likes});
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  Future<PostModel?> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;
      return PostModel(
        id: data['id'] ?? postId,
        userId: data['userId'],
        userDisplayName: data['userDisplayName'],
        userPhotoUrl: data['userPhotoUrl'],
        imageUrl: data['imageUrl'],
        caption: data['caption'],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        likes: List<String>.from(data['likes'] ?? []),
        commentCount: data['commentCount'] ?? 0,
      );
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  Future<void> updatePost(String postId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('posts').doc(postId).update(updates);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final commentsSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      final batch = _firestore.batch();

      for (final doc in commentsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(_firestore.collection('posts').doc(postId));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      final commentData = {
        'id': commentRef.id,
        'userId': comment.userId,
        'userName': comment.userName,
        'userPhotoUrl': comment.userPhotoUrl,
        'text': comment.text,
        'timestamp': Timestamp.fromDate(comment.timestamp),
      };

      await commentRef.set(commentData);

      await _incrementCommentCount(postId);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return CommentModel(
              id: data['id'],
              userId: data['userId'],
              userName: data['userName'],
              userPhotoUrl: data['userPhotoUrl'],
              text: data['text'],
              timestamp: (data['timestamp'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  Future<void> _incrementCommentCount(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'commentCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to increment comment count: $e');
    }
  }
}
