class GetRequestModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final RequestData data;
  final Notes notes;

  GetRequestModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  // تحويل من JSON إلى كائن Dart
  factory GetRequestModel.fromJson(Map<String, dynamic> json) {
    return GetRequestModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'] ?? [],
      data: RequestData.fromJson(json['data']),
      notes: Notes.fromJson(json['notes']),
    );
  }
}

class RequestData {
  final List<Request> requests;

  RequestData({required this.requests});

  // تحويل من JSON إلى كائن Dart
  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      requests:
          List<Request>.from(json['reqeust'].map((x) => Request.fromJson(x))),
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
    required this.time,
    required this.distance,
    required this.price,
    required this.stops,
  });

  // تحويل من JSON إلى كائن Dart
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
      price: json['price'].toDouble(),
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

  // تحويل من JSON إلى كائن Dart
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

class Notes {
  final List<String> vehicleTypes;

  Notes({required this.vehicleTypes});

  // تحويل من JSON إلى كائن Dart
  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      vehicleTypes: List<String>.from(json['Vehicle Types'] ?? []),
    );
  }
}
