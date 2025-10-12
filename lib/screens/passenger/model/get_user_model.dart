class GetUserModel {
  final bool status;
  final String message;
  final List<String> errors;
  final UserData data;
  final List<String> notes;

  GetUserModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      status: json['status'],
      message: json['message'],
      errors: List<String>.from(json['errors']),
      data: UserData.fromJson(json['data']['user']),
      notes: List<String>.from(json['notes']),
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? picture;
  final int joinedWith;
  final String superKey;
  final String uniqueId;
  final int isEmailVerified;
  final String? emailVerifiedAt;
  final String? emailLastVerificationCode;
  final String? emailLastVerificationCodeExpiredAt;
  final String createdAt;
  final String updatedAt;
  final int isAdmin;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.picture,
    required this.joinedWith,
    required this.superKey,
    required this.uniqueId,
    required this.isEmailVerified,
    this.emailVerifiedAt,
    this.emailLastVerificationCode,
    this.emailLastVerificationCodeExpiredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isAdmin,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      picture: json['picture'],
      joinedWith: json['joined_with'],
      superKey: json['super_key'],
      uniqueId: json['unique_id'],
      isEmailVerified: json['is_email_verified'],
      emailVerifiedAt: json['email_verified_at'],
      emailLastVerificationCode: json['email_last_verfication_code'],
      emailLastVerificationCodeExpiredAt:
          json['email_last_verfication_code_expird_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isAdmin: json['is_admin'],
    );
  }
}
