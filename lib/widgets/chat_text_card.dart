import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';

class ChatTextCard extends StatelessWidget {
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;

  const ChatTextCard({
    required this.message,
    required this.userName,
    required this.isMe,
    required this.userImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe)
              const SizedBox(
                width: 49,
              ),
            Container(
              width: mediaQuery.size.width > webScreenSize ? 200 : 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isMe ? blueColor : Colors.grey[800],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!isMe)
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: CircleAvatar(
                backgroundColor: secondaryColor,
                backgroundImage: NetworkImage(
                  userImage,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
