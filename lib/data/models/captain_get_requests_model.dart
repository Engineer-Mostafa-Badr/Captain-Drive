class CaptainGetRequestModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final Data? data;
  final List<dynamic> notes;

  CaptainGetRequestModel({
    required this.status,
    required this.message,
    required this.errors,
    this.data,
    required this.notes,
  });

  factory CaptainGetRequestModel.fromJson(Map<String, dynamic> json) {
    // Check the type of 'data' to ensure it is a Map before parsing.
    var data = json['data'];
    Data? parsedData;

    if (data is Map<String, dynamic>) {
      parsedData = Data.fromJson(data);
    } else {
      parsedData = null; // Set to null if data is not a Map.
    }

    return CaptainGetRequestModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'] ?? [],
      data: parsedData,
      notes: json['notes'] ?? [],
    );
  }
}

class Data {
  final List<Request> requests;

  Data({required this.requests});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      requests: (json['requests'] as List<dynamic>)
          .map((request) => Request.fromJson(request))
          .toList(),
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
  final String? time;
  final num? distance;
  final num? price;
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      vehicle: json['vehicle'],
      stLocation: json['st_location'],
      enLocation: json['en_location'],
      type: json['type'],
      time: json['time'],
      distance: json['distance'],
      price: json['price'],
      stops: (json['stops'] as List<dynamic>)
          .map((stop) => Stop.fromJson(stop))
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
