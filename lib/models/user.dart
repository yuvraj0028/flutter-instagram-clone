import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": userName,
        "uid": uid,
        "email": email,
        "photourl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return User(
      email: data['email'],
      uid: data['uid'],
      photoUrl: data['photourl'],
      userName: data['username'],
      bio: data['bio'],
      followers: data['followers'],
      following: data['following'],
    );
  }
}
