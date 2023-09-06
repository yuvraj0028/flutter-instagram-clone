import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String desc;
  final String uid;
  final String userName;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final dynamic likes;

  const Post({
    required this.desc,
    required this.uid,
    required this.userName,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "uid": uid,
        "username": userName,
        "postid": postId,
        "datepublished": datePublished,
        "posturl": postUrl,
        "profileimage": profileImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Post(
      desc: data['desc'],
      uid: data['uid'],
      userName: data['username'],
      postId: data['postid'],
      datePublished: data['datepublished'],
      postUrl: data['posturl'],
      profileImage: data['profileimage'],
      likes: data['likes'],
    );
  }
}
