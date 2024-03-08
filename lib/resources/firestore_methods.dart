import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    // ASKING UID HERE BECAUSE WE DONT WANT TO MAKE EXTRA CALLS TO FIREBASE AUTH WHEN WE CAN JUST GET FROM OUR STATE MANAGEMENT
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
// CREATES UNIQUE ID BASED ON TIME
      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        savedPostUsers: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

//  LIKE POST
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // POST COMMENT
  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // IF THE LIKES LIST CONTAINS THE USER UID, WE NEED TO REMOVE IT
        String commentId = const Uuid().v1();

        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });

        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // DELETE POST
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

// FOLLOW USER
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  savedPosts(String postId) async {
    var doc = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('savedPosts')
        .doc(postId)
        .get();

// REMOVE DATA FROM SAVEDPOST
    if (doc.exists) {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('savedPosts')
          .doc(postId)
          .delete();
    }
// ADD SAVEDPOST IN DATABASE
    else {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('savedPosts')
          .doc(postId)
          .set({});
    }
  }

  //  SAVED POST USERS
  Future<String> savedPostUsers(
      String postId, String uid, List savedPostUsers) async {
    String res = "Some error occurred";
    try {
      if (savedPostUsers.contains(uid)) {
        // if the savedPostUsers list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'savedPostUsers': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the savedPostUsers array
        _firestore.collection('posts').doc(postId).update({
          'savedPostUsers': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
