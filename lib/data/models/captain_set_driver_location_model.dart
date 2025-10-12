class DriverSetCurrentLocationModel {
  bool status;
  String message;
  List<String> errors;
  DriverData data;
  List<String> notes;

  DriverSetCurrentLocationModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory DriverSetCurrentLocationModel.fromJson(Map<String, dynamic> json) {
    return DriverSetCurrentLocationModel(
      status: json['status'],
      message: json['message'],
      errors: List<String>.from(json['errors']),
      data: DriverData.fromJson(json['data']),
      notes: List<String>.from(json['notes']),
    );
  }
}

class DriverData {
  Driver driver;

  DriverData({
    required this.driver,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      driver: Driver.fromJson(json['driver']),
    );
  }
}

class Driver {
  int id;
  String name;
  String email;
  String phone;
  String password;
  String addPhone;
  String nationalId;
  String picture;
  String socialStatus;
  String gender;
  String status;
  String lng;
  String lat;
  String superKey;
  String uniqueId;
  dynamic rate;
  dynamic successfulRides;
  int isEmailVerified;
  dynamic emailVerifiedAt;
  dynamic emailLastVerificationCode;
  dynamic emailLastVerificationCodeExpiredAt;
  dynamic rememberToken;
  String createdAt;
  String updatedAt;
  int isApproved;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.addPhone,
    required this.nationalId,
    required this.picture,
    required this.socialStatus,
    required this.gender,
    required this.status,
    required this.lng,
    required this.lat,
    required this.superKey,
    required this.uniqueId,
    required this.rate,
    required this.successfulRides,
    required this.isEmailVerified,
    required this.emailVerifiedAt,
    required this.emailLastVerificationCode,
    required this.emailLastVerificationCodeExpiredAt,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.isApproved,
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
}
