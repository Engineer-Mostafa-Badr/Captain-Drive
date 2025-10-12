import 'package:captain_drive/screens/captain/chat/chat_view.dart';
import 'package:captain_drive/screens/captain/chat/models/message_model.dart';
import 'package:flutter/material.dart';

class RecentChats extends StatelessWidget {
  const RecentChats({
    super.key,
    required this.messages,
    required this.currentUserEmail,
  });

  final List<MessageModel> messages;
  final String currentUserEmail;

  @override
  Widget build(BuildContext context) {
    // Filter messages involving the current user
    final filteredMessages = messages.where((message) {
      return message.userId == currentUserEmail ||
          message.receiverId == currentUserEmail;
    }).toList();

    // Sort messages by creation date in descending order
    filteredMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      itemCount: filteredMessages.length,
      itemBuilder: (context, index) {
        final message = filteredMessages[index];

        // Check if the current user is the sender or the receiver
        final isCurrentUserSender = message.userId == currentUserEmail;

        // Set the correct details based on the current user's role
        final chatPartnerName =
            isCurrentUserSender ? message.receiverName : message.senderName;
        final chatPartnerProfileImageUrl = isCurrentUserSender
            ? message.receiverProfileImageUrl
            : message.senderProfileImageUrl;
        final chatPartnerEmail =
            isCurrentUserSender ? message.receiverId : message.userId;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatView(
                  receiverEmail: chatPartnerEmail,
                  receiverName: chatPartnerName,
                  receiverProfileImageUrl: chatPartnerProfileImageUrl,
                ),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                ClipOval(
                  child: chatPartnerProfileImageUrl != null &&
                          chatPartnerProfileImageUrl.isNotEmpty
                      ? Image.network(
                          chatPartnerProfileImageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/image.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatPartnerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        message.isImage == false ? message.message : 'Photo',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatDate(message.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.month}/${date.day}/${date.year}';
    } else if (difference.inDays > 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
