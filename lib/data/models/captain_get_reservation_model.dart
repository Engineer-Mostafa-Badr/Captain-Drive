class CaptainGetReservationModel {
  bool? status;
  String? message;
  List<dynamic>? errors;
  Data? data;
  List<dynamic>? notes;

  CaptainGetReservationModel({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.notes,
  });

  factory CaptainGetReservationModel.fromJson(Map<String, dynamic> json) {
    return CaptainGetReservationModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'],
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? Data.fromJson(json['data'])
          : null,
      notes: json['notes'],
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
  List<ReservationRequest>? reservationRequests;

  Data({this.reservationRequests});

  factory Data.fromJson(Map<String, dynamic> json) {
    if (json['reservation_requests'] != null &&
        json['reservation_requests'] is List) {
      // Ensure that 'reservation_requests' is a valid List
      var reservations = json['reservation_requests'] as List;
      return Data(
        reservationRequests:
            reservations.map((i) => ReservationRequest.fromJson(i)).toList(),
      );
    } else {
      // Handle the case where 'reservation_requests' is null or not a List
      return Data(reservationRequests: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'reservation_requests':
          reservationRequests?.map((i) => i.toJson()).toList(),
    };
  }
}

class ReservationRequest {
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
  double? distance;
  num? price;
  List<Stop>? stops;

  ReservationRequest({
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
      distance: (json['distance'] as num?)?.toDouble(),
      price: json['price'],
      stops: json['stops'] != null
          ? (json['stops'] as List).map((i) => Stop.fromJson(i)).toList()
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
      'stops': stops?.map((i) => i.toJson()).toList(),
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
