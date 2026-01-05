// lib/data/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_social/data/models/comment_model.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get postsCollection => _firestore.collection('posts');

  Future<void> createUser(UserModel user) async {
    await usersCollection.doc(user.uid).set(user.toMap());
  }

Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
  await usersCollection.doc(uid).update(data);
}

  Future<UserModel?> getUser(String uid) async {
    final doc = await usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<String> createPost(PostModel post) async {
    final docRef = await postsCollection.add(post.toMap());
    return docRef.id;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> updates) async {
    await postsCollection.doc(postId).update(updates);
  }

  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  // UPDATED: Added real-time stream for comments
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ))
            .toList());
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    final batch = _firestore.batch();
    
    final commentRef = postsCollection.doc(postId).collection('comments').doc();
    batch.set(commentRef, comment.toMap());

    batch.update(postsCollection.doc(postId), {
      'commentCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Stream<List<PostModel>> getPostsStream() {
    return postsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ))
            .toList());
  }

  Future<PostModel?> getPost(String postId) async {
    final doc = await postsCollection.doc(postId).get();
    if (doc.exists) {
      return PostModel.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }
    return null;
  }
}