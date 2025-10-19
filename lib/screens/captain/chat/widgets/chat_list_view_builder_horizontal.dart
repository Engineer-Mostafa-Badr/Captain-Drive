import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import '../../../../features/chat/driver/presentation/views/chat_view.dart';

class ChatListViewBuilderHorizontal extends StatefulWidget {
  const ChatListViewBuilderHorizontal(
      {super.key, required this.users, required this.currentUserEmail});
  final List<UserEntity> users;
  final String currentUserEmail;

  @override
  State<ChatListViewBuilderHorizontal> createState() =>
      _ChatListViewBuilderHorizontalState();
}

class _ChatListViewBuilderHorizontalState
    extends State<ChatListViewBuilderHorizontal> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Filter out the current user
    final users = widget.users
        .where((user) => user.email != widget.currentUserEmail)
        .toList();

    return ListView.builder(
      itemCount: users.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final user = users[index];
        bool isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatView(
                  receiverEmail: user.email,
                  receiverName: user.name,
                  receiverProfileImageUrl: user.profileImageUrl,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColor.primaryColor
                          : Colors.transparent,
                      width: isSelected ? 4.0 : 0.0,
                    ),
                  ),
                  child: ClipOval(
                    child: user.profileImageUrl != null &&
                            user.profileImageUrl!.isNotEmpty
                        ? Image.network(
                            user.profileImageUrl!,
                            fit: BoxFit.fill,
                          )
                        : Image.asset('assets/images/image.png'),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
