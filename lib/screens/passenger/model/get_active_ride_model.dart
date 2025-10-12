class GetActiveRideModel {
  bool? status;
  String? message;
  List<dynamic>? errors;
  RideData? data;
  Notes? notes;

  GetActiveRideModel({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.notes,
  });

  factory GetActiveRideModel.fromJson(Map<String, dynamic> json) {
    return GetActiveRideModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: json['data'] != null ? RideData.fromJson(json['data']) : null,
      notes: json['notes'] != null ? Notes.fromJson(json['notes']) : null,
    );
  }
}

class RideData {
  Ride? ride;

  RideData({this.ride});

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      ride: json['ride'] != null ? Ride.fromJson(json['ride']) : null,
    );
  }
}

class Ride {
  int? id;
  int? offerId;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic rate;
  dynamic review;
  Offer? offer;

  Ride({
    this.id,
    this.offerId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.rate,
    this.review,
    this.offer,
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
      offer: json['offer'] != null ? Offer.fromJson(json['offer']) : null,
    );
  }
}

class Offer {
  int? id;
  int? driverId;
  int? requestId;
  double? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  Request? request;
  Driver? driver;

  Offer({
    this.id,
    this.driverId,
    this.requestId,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.request,
    this.driver,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price']?.toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      request:
          json['request'] != null ? Request.fromJson(json['request']) : null,
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }
}

class Request {
  int? id;
  int? userId;
  String? stLng;
  String? stLat;
  String? enLng;
  String? enLat;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? vehicle;
  String? stLocation;
  String? enLocation;
  String? type;
  dynamic time;
  double? distance;
  double? price;
  List<dynamic>? stops;

  Request({
    this.id,
    this.userId,
    this.stLng,
    this.stLat,
    this.enLng,
    this.enLat,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vehicle,
    this.stLocation,
    this.enLocation,
    this.type,
    this.time,
    this.distance,
    this.price,
    this.stops,
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
      distance: json['distance']?.toDouble(),
      price: json['price']?.toDouble(),
      stops: json['stops'] ?? [],
    );
  }
}

class Driver {
  int? id;
  String? name;
  String? email;
  String? phone;
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
  bool? isEmailVerified;
  String? createdAt;
  String? updatedAt;
  bool? isApproved;

  Driver({
    this.id,
    this.name,
    this.email,
    this.phone,
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
      isEmailVerified: json['is_email_verified'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isApproved: json['is_approved'] == 1,
    );
  }
}

class Notes {
  List<String>? vehicleTypes;

  Notes({this.vehicleTypes});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      vehicleTypes: json['Vehicle Types'] != null
          ? List<String>.from(json['Vehicle Types'])
          : [],
    );
  }
}
