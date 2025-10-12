class GetReservationModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final ReservationData? data; // Use nullable for the data field
  final List<dynamic> notes;

  GetReservationModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory GetReservationModel.fromJson(Map<String, dynamic> json) {
    return GetReservationModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: json['data'] is Map<String, dynamic>
          ? ReservationData.fromJson(json['data'])
          : null,
      notes: json['notes'] ?? [],
    );
  }
}

class ReservationData {
  final Request request;

  ReservationData({required this.request});

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      request: Request.fromJson(json['reqeust']),
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
  final double distance;
  final num price;
  final List<dynamic> stops;

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
      distance: json['distance'].toDouble(),
      price: json['price'],
      stops: json['stops'] ?? [],
    );
  }
}
