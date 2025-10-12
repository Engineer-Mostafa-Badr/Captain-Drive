class ReservationRequestModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final ReservationData data;
  final List<dynamic> notes;

  ReservationRequestModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory ReservationRequestModel.fromJson(Map<String, dynamic> json) {
    return ReservationRequestModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: ReservationData.fromJson(json['data']),
      notes: json['notes'] ?? [],
    );
  }
}

class ReservationData {
  final ReservationRequest reservationRequest;

  ReservationData({required this.reservationRequest});

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      reservationRequest:
          ReservationRequest.fromJson(json['reservation_request']),
    );
  }
}

class ReservationRequest {
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
  final double distance;
  final num price;
  final List<Stop> stops;

  ReservationRequest({
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
    required this.distance,
    required this.price,
    required this.stops,
  });

  factory ReservationRequest.fromJson(Map<String, dynamic> json) {
    return ReservationRequest(
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
      price: json['price'],
      stops: (json['stops'] as List<dynamic>)
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
