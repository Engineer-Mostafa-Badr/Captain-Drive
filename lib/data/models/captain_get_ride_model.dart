class CaptainGetRideModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final RideData? data;
  final List<dynamic> notes;

  CaptainGetRideModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory CaptainGetRideModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    RideData? parsedData;

    if (data is Map<String, dynamic>) {
      parsedData = RideData.fromJson(data);
    } else {
      parsedData = null; // Set to null if data is not a Map.
    }

    return CaptainGetRideModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      errors: json['errors'] as List<dynamic>,
      data: parsedData,
      notes: json['notes'] as List<dynamic>,
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

class RideData {
  final Ride? ride;

  RideData({required this.ride});

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
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
  final int id;
  final int offerId;
  final String createdAt;
  final String updatedAt;
  final String status;
  final dynamic rate;
  final dynamic review;
  final Offer? offer;

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
      id: json['id'] as int,
      offerId: json['offer_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      status: json['status'] as String,
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
  final int id;
  final int driverId;
  final int requestId;
  final int price;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Request? request;

  Offer({
    required this.id,
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as int,
      driverId: json['driver_id'] as int,
      requestId: json['request_id'] as int,
      price: json['price'] as int,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
  final int price;
  final List<Stop> stops;

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
    required this.stops,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      stLng: json['st_lng'] as String,
      stLat: json['st_lat'] as String,
      enLng: json['en_lng'] as String,
      enLat: json['en_lat'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      vehicle: json['vehicle'] as int,
      stLocation: json['st_location'] as String,
      enLocation: json['en_location'] as String,
      type: json['type'] as String,
      time: json['time'],
      distance: (json['distance'] as num).toDouble(),
      price: json['price'] as int,
      stops: (json['stops'] as List<dynamic>)
          .map((stop) => Stop.fromJson(stop))
          .toList(),
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
      'stops': stops.map((stop) => stop.toJson()).toList(),
    };
  }
}

class Stop {
  final int id;
  final int rideRequestId;
  final String stopLocation;
  final String lng;
  final String lat;
  final String createdAt;
  final String updatedAt;

  Stop({
    required this.id,
    required this.rideRequestId,
    required this.stopLocation,
    required this.lng,
    required this.lat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'] as int,
      rideRequestId: json['ride_request_id'] as int,
      stopLocation: json['stop_location'] as String,
      lng: json['lng'] as String,
      lat: json['lat'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
