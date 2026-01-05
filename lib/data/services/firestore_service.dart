// lib/data/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get postsCollection => _firestore.collection('posts');

  Future<void> createUser(UserModel user) async {
    await usersCollection.doc(user.uid).set(user.toMap());
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

Stream<List<PostModel>> getPostsStream() {
  return postsCollection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PostModel.fromMap(
                doc.id, // ID is the first argument (String)
                doc.data() as Map<String, dynamic>, // Data is the second (Map)
              ))
          .toList());
}
  Future<PostModel?> getPost(String postId) async {
    final doc = await postsCollection.doc(postId).get();
    if (doc.exists) {
      return PostModel.fromMap(
        doc.id, // ID first
        doc.data() as Map<String, dynamic>, // Map second
      );
    }
    return null;
  }
}