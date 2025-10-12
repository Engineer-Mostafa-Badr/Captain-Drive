import 'vehicle.dart';
import 'wallet.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? addPhone;
  String? nationalId;
  String? picture;
  String? socialStatus;
  String? gender;
  String? status;
  dynamic lng;
  dynamic lat;
  String? superKey;
  String? uniqueId;
  dynamic rate;
  dynamic successfulRides;
  int? isEmailVerified;
  dynamic emailVerifiedAt;
  dynamic emailLastVerficationCode;
  dynamic emailLastVerficationCodeExpirdAt;
  dynamic rememberToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isApproved;
  Vehicle? vehicle;
  Wallet? wallet;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.addPhone,
    this.nationalId,
    this.picture,
    this.socialStatus,
    this.gender,
    this.status,
    this.lng,
    this.lat,
    this.superKey,
    this.uniqueId,
    this.rate,
    this.successfulRides,
    this.isEmailVerified,
    this.emailVerifiedAt,
    this.emailLastVerficationCode,
    this.emailLastVerficationCodeExpirdAt,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.isApproved,
    this.vehicle,
    this.wallet,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      addPhone: json['add_phone'] as String?,
      nationalId: json['national_id'] as String?,
      picture: json['picture'] as String?,
      socialStatus: json['social_status'] as String?,
      gender: json['gender'] as String?,
      status: json['status'] as String?,
      lng: json['lng'] as dynamic,
      lat: json['lat'] as dynamic,
      superKey: json['super_key'] as String?,
      uniqueId: json['unique_id'] as String?,
      rate: json['rate'] as dynamic,
      successfulRides: json['successful_rides'] as dynamic,
      isEmailVerified: json['is_email_verified'] as int?,
      emailVerifiedAt: json['email_verified_at'] as dynamic,
      emailLastVerficationCode: json['email_last_verfication_code'] as dynamic,
      emailLastVerficationCodeExpirdAt:
          json['email_last_verfication_code_expird_at'] as dynamic,
      rememberToken: json['remember_token'] as dynamic,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isApproved: json['is_approved'] as int?,
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'add_phone': addPhone,
      'national_id': nationalId,
      'picture': picture,
      'social_status': socialStatus,
      'gender': gender,
      'status': status,
      'lng': lng,
      'lat': lat,
      'super_key': superKey,
      'unique_id': uniqueId,
      'rate': rate,
      'successful_rides': successfulRides,
      'is_email_verified': isEmailVerified,
      'email_verified_at': emailVerifiedAt,
      'email_last_verfication_code': emailLastVerficationCode,
      'email_last_verfication_code_expird_at': emailLastVerficationCodeExpirdAt,
      'remember_token': rememberToken,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_approved': isApproved,
      'vehicle': vehicle?.toJson(),
      'wallet': wallet?.toJson(),
    };
  }
}
