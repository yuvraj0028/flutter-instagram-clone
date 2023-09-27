import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/page_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/comment_screen.dart';
import '../utils/colors.dart';
import '../widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  const PostCard({
    required this.snap,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return user != null
        ? Container(
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          widget.snap['profileimage'],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: [
                                  user.uid == widget.snap['uid']
                                      ? 'Delete'
                                      : 'Not Your Post!',
                                ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          final user =
                                              FirebaseAuth.instance.currentUser;

                                          if (user!.uid == widget.snap['uid']) {
                                            FirestoreMethods().deletePost(
                                                widget.snap['postid']);
                                            Navigator.of(context).pop();
                                          } else {
                                            return;
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    ],
                  ),
                ),
                // Image Section
                GestureDetector(
                  onDoubleTap: () async {
                    if (!widget.snap['likes'].contains(user.uid)) {
                      await FirestoreMethods().likePost(
                        widget.snap['postid'],
                        user.uid,
                        widget.snap['likes'],
                      );
                      setState(() {
                        isLikeAnimating = true;
                      });
                    } else {
                      setState(() {
                        isLikeAnimating = true;
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['posturl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: isLikeAnimating ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: LikeAnimation(
                          isAnimation: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Like Comment Section
                Row(
                  children: [
                    LikeAnimation(
                      isAnimation: widget.snap['likes'].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                            widget.snap['postid'],
                            user.uid,
                            widget.snap['likes'],
                          );
                        },
                        icon: widget.snap['likes'].contains(user.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageAnimation.createRoute(
                              page: CommentScreen(
                                snap: widget.snap,
                              ),
                              beginOffset1: 0.0,
                              beginOffset2: 1.0),
                        );
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_outline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Descriptions and comments
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                        child: Text(
                          '${widget.snap['likes'].length} likes',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '   ${widget.snap['desc']}',
                              ),
                            ],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          PageAnimation.createRoute(
                              page: CommentScreen(
                                snap: widget.snap,
                              ),
                              beginOffset1: 0.0,
                              beginOffset2: 1.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(widget.snap['postid'])
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    'View all 0 comments',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: secondaryColor,
                                    ),
                                  );
                                }
                                final length =
                                    (snapshot.data! as dynamic).docs.length;
                                return Text(
                                  'View all $length comments',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: secondaryColor,
                                  ),
                                );
                              }),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datepublished'].toDate()),
                          style: const TextStyle(
                            fontSize: 16,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
