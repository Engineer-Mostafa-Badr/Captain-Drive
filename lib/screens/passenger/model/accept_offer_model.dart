class AcceptOfferModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final OfferData? data;
  final Notes? notes;

  AcceptOfferModel({
    required this.status,
    required this.message,
    required this.errors,
    this.data,
    this.notes,
  });

  factory AcceptOfferModel.fromJson(Map<String, dynamic> json) {
    return AcceptOfferModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: json['data'] != null ? OfferData.fromJson(json['data']) : null,
      notes: json['notes'] != null ? Notes.fromJson(json['notes']) : null,
    );
  }
}

class OfferData {
  final Offer? offer;
  final RideRequest? rideRequest;

  OfferData({
    this.offer,
    this.rideRequest,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      offer: json['offer'] != null ? Offer.fromJson(json['offer']) : null,
      rideRequest: json['ride_request'] != null
          ? RideRequest.fromJson(json['ride_request'])
          : null,
    );
  }
}

class Offer {
  final int id;
  final int driverId;
  final int requestId;
  final double price;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Driver? driver;

  Offer({
    required this.id,
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.driver,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'].toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }
}

class Driver {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String addPhone;
  final String nationalId;
  final String picture;
  final String socialStatus;
  final String gender;
  final String status;
  final String lng;
  final String lat;
  final String superKey;
  final String uniqueId;
  final double? rate;
  final int? successfulRides;
  final int isEmailVerified;
  final String? emailVerifiedAt;
  final String? emailLastVerificationCode;
  final String? emailLastVerificationCodeExpiredAt;
  final String? rememberToken;
  final String createdAt;
  final String updatedAt;
  final int isApproved;

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
    this.rate,
    this.successfulRides,
    required this.isEmailVerified,
    this.emailVerifiedAt,
    this.emailLastVerificationCode,
    this.emailLastVerificationCodeExpiredAt,
    this.rememberToken,
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
      rate: json['rate']?.toDouble(),
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

class RideRequest {
  final int id;
  final int userId;
  final String stLng;
  final String stLat;
  final String enLng;
  final String enLat;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int vehicle;
  final String stLocation;
  final String enLocation;
  final String type;
  final String? time;
  final double distance;
  final double price;

  RideRequest({
    required this.id,
    required this.userId,
    required this.stLng,
    required this.stLat,
    required this.enLng,
    required this.enLat,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicle,
    required this.stLocation,
    required this.enLocation,
    required this.type,
    this.time,
    required this.distance,
    required this.price,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json['id'],
      userId: json['user_id'],
      stLng: json['st_lng'],
      stLat: json['st_lat'],
      enLng: json['en_lng'],
      enLat: json['en_lat'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      vehicle: json['vehicle'],
      stLocation: json['st_location'],
      enLocation: json['en_location'],
      type: json['type'],
      time: json['time'],
      distance: json['distance'].toDouble(),
      price: json['price'].toDouble(),
    );
  }
}

class Notes {
  final List<String> vehicleTypes;

  Notes({
    required this.vehicleTypes,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      vehicleTypes: List<String>.from(json['Vehicle Types']),
    );
  }
}
