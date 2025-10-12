import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:captain_drive/screens/captain/chat/models/message_model.dart';
import 'package:captain_drive/screens/captain/chat/widgets/chat_list_view_builder_horizontal.dart';
import 'package:captain_drive/screens/captain/chat/widgets/recent_chats.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Future<Map<String, UserEntity>> _fetchUserDetails() async {
    try {
      final usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      final users = usersSnapshot.docs.map((doc) {
        return UserEntity(
          email: doc['email'],
          name: doc['name'],
          uId: doc['userId'],
          profileImageUrl: doc['profileImageUrl'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();

      final userMap = {for (var user in users) user.uId: user};
      return userMap;
    } catch (e) {
      print("Failed to fetch user details: $e");
      return {};
    }
  }

  Future<List<MessageModel>> _fetchLastMessagesForEachChat() async {
    try {
      getCurrentUserEmail();
      final snapshot = await FirebaseFirestore.instance
          .collection('messages')
          .orderBy('chatId')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        print("No messages found");
        return [];
      }

      Map<String, MessageModel> lastMessagesMap = {};

      for (var doc in snapshot.docs) {
        final chatId = doc['chatId'];
        doc['userId'];

        if (!lastMessagesMap.containsKey(chatId)) {
          lastMessagesMap[chatId] = MessageModel.fromJson(doc.data());
        }
      }

      return lastMessagesMap.values.toList();
    } catch (e) {
      print("Failed to fetch messages: $e");
      return [];
    }
  }

  Future<Map<String, MessageModel>> _fetchMessagesWithUserDetails() async {
    try {
      final messages = await _fetchLastMessagesForEachChat();

      final enrichedMessages = messages.map((message) {
        return MessageModel(
          message: message.message,
          receiverId: message.receiverId,
          userId: message.userId,
          chatId: message.chatId,
          isImage: message.isImage,
          createdAt: message.createdAt,
          receiverName: message.receiverName,
          receiverProfileImageUrl: message.receiverProfileImageUrl,
          senderName: message.senderName,
          senderProfileImageUrl: CacheHelper.getData(key: 'profileImageUrl'),
        );
      }).toList();

      return {for (var message in enrichedMessages) message.chatId: message};
    } catch (e) {
      print("Failed to fetch messages with user details: $e");
      return {};
    }
  }

  String getCurrentUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = getCurrentUserEmail();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: onBoardingColor),
                        SizedBox(width: 10),
                        Text(
                          'Search here',
                          style:
                              TextStyle(fontSize: 14, color: onBoardingColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Buddies',
                  style: TextStyle(fontSize: 18, fontFamily: 'PoppinsBold'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<List<UserEntity>>(
                    future: _fetchUserDetails()
                        .then((userMap) => userMap.values.toList()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No users found'));
                      } else {
                        return ChatListViewBuilderHorizontal(
                          users: snapshot.data!,
                          currentUserEmail: currentUserEmail,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Chats',
                  style: TextStyle(fontSize: 18, fontFamily: 'PoppinsBold'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: FutureBuilder<List<MessageModel>>(
                    future: _fetchMessagesWithUserDetails()
                        .then((messageMap) => messageMap.values.toList()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No recent chats found'));
                      } else {
                        return RecentChats(
                          messages: snapshot.data!,
                          currentUserEmail: currentUserEmail,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
