class CaptainGetDriverReservationModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final ReservationData? data;
  final List<dynamic> notes;

  CaptainGetDriverReservationModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory CaptainGetDriverReservationModel.fromJson(Map<String, dynamic> json) {
    // Check if 'data' is a Map before attempting to parse it as ReservationData
    final data = json['data'];
    ReservationData? reservationData;

    if (data is Map<String, dynamic>) {
      reservationData = ReservationData.fromJson(data);
    } else {
      // Handle case where 'data' is not a Map (e.g., when it's a list or null)
      reservationData = null; // You can set to null or create an empty instance
    }

    return CaptainGetDriverReservationModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: reservationData,
      notes: json['notes'] ?? [],
    );
  }
}

class ReservationData {
  final Reservation reservation;

  ReservationData({
    required this.reservation,
  });

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      reservation: Reservation.fromJson(json['reservation']),
    );
  }
}

class Reservation {
  final int id;
  final int offerId;
  final String createdAt;
  final String updatedAt;
  final String status;
  final dynamic rate;
  final dynamic review;
  final Offer offer;

  Reservation({
    required this.id,
    required this.offerId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.rate,
    this.review,
    required this.offer,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
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
  final int price;
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
      price: json['price'],
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
  final String time;
  final dynamic distance;
  final dynamic price;
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
    required this.time,
    this.distance,
    this.price,
    required this.stops,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    var stopsList = json['stops'] as List;
    List<Stop> stops = stopsList.map((i) => Stop.fromJson(i)).toList();

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
      stops: stops,
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
