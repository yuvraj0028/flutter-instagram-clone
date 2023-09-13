import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_post_screen.dart';
import '../utils/colors.dart';
import '../providers/user_provider.dart';

class AddStory extends StatelessWidget {
  const AddStory({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return user != null
        ? GestureDetector(
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
                    backgroundImage: NetworkImage(user.photoUrl),
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
          )
        : Container();
  }
}
