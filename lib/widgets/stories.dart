import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/stories_screen.dart';
import '../utils/colors.dart';
import '../utils/page_animation.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('stories').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return StoriesCard(snap: snapshot.data!.docs[index].data());
              },
            );
          }),
    );
  }
}

class StoriesCard extends StatelessWidget {
  const StoriesCard({
    super.key,
    required this.snap,
  });

  final dynamic snap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageAnimation.createRoute(
              page: StoriesScreen(
                username: snap['username'],
                profPic: snap['userimage'],
                uid: snap['uid'],
              ),
              beginOffset1: 0.0,
              beginOffset2: 1.0),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromARGB(255, 237, 101, 232),
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(snap['userimage']),
            backgroundColor: secondaryColor,
            radius: 40,
          ),
        ),
      ),
    );
  }
}
