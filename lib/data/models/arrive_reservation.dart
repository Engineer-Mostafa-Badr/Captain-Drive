class ArriveReservation {
  bool? status;
  String? message;
  List<dynamic>? errors;
  Data? data;
  List<dynamic>? notes;

  ArriveReservation({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.notes,
  });

  factory ArriveReservation.fromJson(Map<String, dynamic> json) {
    return ArriveReservation(
      status: json['status'],
      message: json['message'],
      errors:
          json['errors'] != null ? List<dynamic>.from(json['errors']) : null,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      notes: json['notes'] != null ? List<dynamic>.from(json['notes']) : null,
    );
  }

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

class Data {
  Ride? ride;

  Data({this.ride});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      ride: json['ride'] != null ? Ride.fromJson(json['ride']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride': ride?.toJson(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer_id': offerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'rate': rate,
      'review': review,
      'offer': offer?.toJson(),
    };
  }
}

class Offer {
  int? id;
  int? driverId;
  int? requestId;
  int? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  Request? request;

  Offer({
    this.id,
    this.driverId,
    this.requestId,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.request,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      request:
          json['request'] != null ? Request.fromJson(json['request']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'request_id': requestId,
      'price': price,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'request': request?.toJson(),
    };
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
  String? time;
  dynamic distance;
  dynamic price;
  List<Stop>? stops;

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
      distance: json['distance'],
      price: json['price'],
      stops: json['stops'] != null
          ? List<Stop>.from(json['stops'].map((stop) => Stop.fromJson(stop)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'st_lng': stLng,
      'st_lat': stLat,
      'en_lng': enLng,
      'en_lat': enLat,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'vehicle': vehicle,
      'st_location': stLocation,
      'en_location': enLocation,
      'type': type,
      'time': time,
      'distance': distance,
      'price': price,
      'stops': stops?.map((stop) => stop.toJson()).toList(),
    };
  }
}

class Stop {
  int? id;
  int? rideRequestId;
  String? stopLocation;
  String? lng;
  String? lat;
  String? createdAt;
  String? updatedAt;

  Stop({
    this.id,
    this.rideRequestId,
    this.stopLocation,
    this.lng,
    this.lat,
    this.createdAt,
    this.updatedAt,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'],
      rideRequestId: json['ride_request_id'],
      stopLocation: json['stop_location'],
      lng: json['lng'],
      lat: json['lat'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_request_id': rideRequestId,
      'stop_location': stopLocation,
      'lng': lng,
      'lat': lat,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
