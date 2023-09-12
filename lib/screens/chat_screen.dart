import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/chat_text_card.dart';
import '../widgets/text_field_input.dart';
import '../api/fcm_api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageText = TextEditingController();

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    messageText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MediaQuery.of(context).size.width > webScreenSize
            ? null
            : AppBar(
                title: const Text('Messages'),
                backgroundColor: mobileBackgroundColor,
              ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = snapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  return ChatTextCard(
                    message: chatDocs[index]['text'],
                    userName: chatDocs[index]['username'],
                    isMe: chatDocs[index]['uid'] == user!.uid,
                    userImage: chatDocs[index]['userimage'],
                  );
                },
              );
            }),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldInput(
                      textEditingController: messageText,
                      hintText: 'message',
                      textInputType: TextInputType.text,
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(left: 0),
                  onPressed: () {
                    String message = messageText.text.trim();
                    if (message.isEmpty) return;

                    FirestoreMethods().sendMessage(
                      message,
                      Timestamp.now(),
                    );
                    FirebaseApi().sendFcmMessage('Chat', message);
                    messageText.clear();
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
