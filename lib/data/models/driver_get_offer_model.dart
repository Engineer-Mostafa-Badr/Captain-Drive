class DriverGetOfferModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final ReservationData? data;
  final List<dynamic> notes;

  DriverGetOfferModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory DriverGetOfferModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    ReservationData? reservationData;

    if (data is Map<String, dynamic>) {
      reservationData = ReservationData.fromJson(data);
    } else {
      // Handle case where 'data' is not a Map (e.g., when it's a list or null)
      reservationData = null; // You can set to null or create an empty instance
    }

    return DriverGetOfferModel(
      status: json['status'],
      message: json['message'],
      errors: List<dynamic>.from(json['errors']),
      data: reservationData,
      notes: List<dynamic>.from(json['notes']),
    );
  }
}

class ReservationData {
  final List<ReservationOffer> reservationOffers;

  ReservationData({required this.reservationOffers});

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      reservationOffers: List<ReservationOffer>.from(
        json['reservation_offers'].map((x) => ReservationOffer.fromJson(x)),
      ),
    );
  }
}

class ReservationOffer {
  final int id;
  final int driverId;
  final int requestId;
  final double price;
  final String status;
  final String createdAt;
  final DateTime updatedAt;
  final Request request;

  ReservationOffer({
    required this.id,
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
  });

  factory ReservationOffer.fromJson(Map<String, dynamic> json) {
    return ReservationOffer(
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'].toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: DateTime.parse(json['updated_at']),
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final int vehicle;
  final String stLocation;
  final String enLocation;
  final String type;
  final String? time;
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
    this.time,
    this.distance,
    this.price,
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      vehicle: json['vehicle'],
      stLocation: json['st_location'],
      enLocation: json['en_location'],
      type: json['type'],
      time: json['time'],
      distance: json['distance'],
      price: json['price'],
      stops: List<Stop>.from(json['stops'].map((x) => Stop.fromJson(x))),
    );
  }
}

class Stop {
  final int id;
  final int rideRequestId;
  final String stopLocation;
  final String lng;
  final String lat;
  final DateTime createdAt;
  final DateTime updatedAt;

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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
