class SetArriveRideModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final RideData data;
  final List<dynamic> notes;

  SetArriveRideModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory SetArriveRideModel.fromJson(Map<String, dynamic> json) {
    return SetArriveRideModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: RideData.fromJson(json['data']),
      notes: json['notes'] ?? [],
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
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      request: Request.fromJson(json['request']),
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
      distance: (json['distance'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      stops: (json['stops'] as List)
          .map((stopJson) => Stop.fromJson(stopJson))
          .toList(),
    );
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
      id: json['id'],
      rideRequestId: json['ride_request_id'],
      stopLocation: json['stop_location'],
      lng: json['lng'],
      lat: json['lat'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
