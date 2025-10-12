class SetToDestinationModel {
  final bool status;
  final String message;
  final RideData data;

  SetToDestinationModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SetToDestinationModel.fromJson(Map<String, dynamic> json) {
    return SetToDestinationModel(
      status: json['status'],
      message: json['message'],
      data: RideData.fromJson(json['data']),
    );
  }
}

class RideData {
  final Ride ride;

  RideData({required this.ride});

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      ride: Ride.fromJson(json['ride']),
    );
  }
}

class Ride {
  final int id;
  final int offerId;
  final String createdAt;
  final String updatedAt;
  final String status;
  final dynamic rate;
  final dynamic review;
  final Offer offer;

  Ride({
    required this.id,
    required this.offerId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.rate,
    this.review,
    required this.offer,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      offerId: json['offer_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      rate: json['rate'],
      review: json['review'],
      offer: Offer.fromJson(json['offer']),
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
  final Request request;
  final Driver driver;

  Offer({
    required this.id,
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
    required this.driver,
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
      request: Request.fromJson(json['request']),
      driver: Driver.fromJson(json['driver']),
    );
  }
}

class Request {
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
  final dynamic time;
  final double distance;
  final double price;

  Request({
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

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
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
  final dynamic rate;
  final dynamic successfulRides;
  final int isEmailVerified;
  final dynamic emailVerifiedAt;
  final dynamic emailLastVerificationCode;
  final dynamic emailLastVerificationCodeExpiredAt;
  final dynamic rememberToken;
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
