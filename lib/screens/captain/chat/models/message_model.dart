import 'package:captain_drive/screens/captain/chat/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String userId;
  final String receiverId;
  final String receiverName;
  final String? receiverProfileImageUrl;
  final String senderName; // Added sender's name
  final String? senderProfileImageUrl; // Added sender's profile image
  final DateTime createdAt;
  final String chatId;
  final bool isImage;

  MessageModel({
    required this.message,
    required this.userId,
    required this.receiverId,
    required this.receiverName,
    this.receiverProfileImageUrl,
    required this.senderName, // Added sender's name
    this.senderProfileImageUrl, // Added sender's profile image
    required this.createdAt,
    required this.chatId,
    required this.isImage,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json[kMessage] ?? '',
      userId: json['userId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverProfileImageUrl: json['receiverProfileImageUrl'],
      senderName: json['senderName'] ?? '', // Added sender's name
      senderProfileImageUrl:
          json['senderProfileImageUrl'], // Added sender's profile image
      createdAt: (json[kCreatedAt] as Timestamp).toDate(),
      chatId: json['chatId'] ?? '',
      isImage: json['isImage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      kMessage: message,
      'userId': userId,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverProfileImageUrl': receiverProfileImageUrl,
      'senderName': senderName, // Added sender's name
      'senderProfileImageUrl':
          senderProfileImageUrl, // Added sender's profile image
      kCreatedAt: Timestamp.fromDate(createdAt),
      'chatId': chatId,
      'isImage': isImage,
    };
  }
}
