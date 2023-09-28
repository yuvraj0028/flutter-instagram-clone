import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import './storage_methods.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost(
    String desc,
    Uint8List file,
    String uid,
    String userName,
    String profileImage,
  ) async {
    String res = 'Some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        desc: desc,
        uid: uid,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postComments(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.trim().isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
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
      } else {
        debugPrint('Text is empty');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendMessage(
    String message,
    Timestamp time,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final userdata =
          await _firestore.collection('users').doc(user!.uid).get();

      await _firestore.collection('chats').add({
        'text': message,
        'username': userdata['username'],
        'uid': user.uid,
        'userimage': userdata['photourl'],
        'createdAt': time,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> addStory(
    Uint8List file,
  ) async {
    String res = 'Some error occured';

    try {
      final user = FirebaseAuth.instance.currentUser;

      final userdata =
          await _firestore.collection('users').doc(user!.uid).get();
      String photoUrl =
          await StorageMethods().uploadImageToStorage('stories', file, true);

      final collectionRef =
          await _firestore.collection('stories').doc(user.uid).get();

      if (collectionRef.exists) {
        await _firestore.collection('stories').doc(user.uid).update({
          'storyimg': FieldValue.arrayUnion([photoUrl]),
          'postedAt': DateTime.now().day,
        });
      } else {
        await _firestore.collection('stories').doc(user.uid).set({
          'storyimg': [photoUrl],
          'username': userdata['username'],
          'uid': user.uid,
          'userimage': userdata['photourl'],
          'postedAt': DateTime.now().day,
        });
      }

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<List<dynamic>> getStories(String uid) async {
    List<dynamic> images = [];

    final collectionRef = await _firestore.collection('stories').doc(uid).get();

    images = collectionRef['storyimg'];

    return images;
  }

  Future<void> refreshStories() async {
    try {
      int currDate = DateTime.now().day;
      List<String> uids = [];

      final users = await _firestore.collection('users').get();

      for (var element in users.docs) {
        uids.add(element.id);
      }

      final stories = await _firestore.collection('stories').get();

      for (var e in stories.docs) {
        if (uids.contains(e.id)) {
          int storyDate = e['postedAt'];
          if (currDate - storyDate > 0) {
            await _firestore.collection('stories').doc(e.id).delete();
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
