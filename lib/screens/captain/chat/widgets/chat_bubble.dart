import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/screens/captain/chat/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: message.isImage
          ? Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  message.message,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                message.message,
                style: const TextStyle(color: Colors.black),
              ),
            ),
    );
  }
}

class ChatBubbleForFriend extends StatelessWidget {
  const ChatBubbleForFriend({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: message.isImage
          ? Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  message.message,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                message.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
