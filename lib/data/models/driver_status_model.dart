class DriverStatusModel {
  bool? status;
  String? message;
  List<dynamic>? errors;
  Data? data;
  List<dynamic>? notes;

  DriverStatusModel({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.notes,
  });

  // Factory constructor to create a ResponseModel object from JSON
  factory DriverStatusModel.fromJson(Map<String, dynamic> json) {
    return DriverStatusModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      notes: json['notes'] ?? [],
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'errors': errors,
      'data': data?.toJson(),
      'notes': notes,
    };
  }
}

// Data Model containing Driver
class Data {
  Driver? driver;

  Data({this.driver});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver': driver?.toJson(),
    };
  }
}

// Driver Model
class Driver {
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
  String? lng;
  String? lat;
  String? superKey;
  String? uniqueId;
  dynamic rate;
  dynamic successfulRides;
  int? isEmailVerified;
  dynamic emailVerifiedAt;
  dynamic emailLastVerificationCode;
  dynamic emailLastVerificationCodeExpiredAt;
  dynamic rememberToken;
  String? createdAt;
  String? updatedAt;
  int? isApproved;

  Driver({
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
    this.emailLastVerificationCode,
    this.emailLastVerificationCodeExpiredAt,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.isApproved,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      addPhone: json['add_phone'],
      nationalId: json['national_id'],
      picture: json['picture'],
      socialStatus: json['social_status'],
      gender: json['gender'],
      status: json['status'],
      lng: json['lng'],
      lat: json['lat'],
      superKey: json['super_key'],
      uniqueId: json['unique_id'],
      rate: json['rate'],
      successfulRides: json['successful_rides'],
      isEmailVerified: json['is_email_verified'],
      emailVerifiedAt: json['email_verified_at'],
      emailLastVerificationCode: json['email_last_verfication_code'],
      emailLastVerificationCodeExpiredAt:
          json['email_last_verfication_code_expird_at'],
      rememberToken: json['remember_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isApproved: json['is_approved'],
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
      'email_last_verfication_code': emailLastVerificationCode,
      'email_last_verfication_code_expird_at':
          emailLastVerificationCodeExpiredAt,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_approved': isApproved,
    };
  }
}
