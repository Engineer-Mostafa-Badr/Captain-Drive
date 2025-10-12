import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String email;
  final String name;
  final String uId;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final String? fcmToken;

  UserEntity({
    required this.email,
    required this.name,
    required this.uId,
    this.profileImageUrl,
    this.createdAt,
    this.fcmToken,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        uId: json['uId'] ?? '',
        profileImageUrl: json['profileImageUrl'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        fcmToken: json['fcmToken'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'uId': uId,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt!),
      'fcmToken': fcmToken,
    };
  }
}
