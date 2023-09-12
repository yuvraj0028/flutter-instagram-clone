import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../utils/colors.dart';

class AddStory extends StatefulWidget {
  const AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  final user = FirebaseAuth.instance.currentUser;
  String? url;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      url = userData['photourl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const AddPost(isPost: false);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.5),
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: secondaryColor,
              backgroundImage: url != null ? NetworkImage(url!) : null,
              radius: 30,
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                size: 20,
                Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
