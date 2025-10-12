class RideRequestModel {
  final bool status;
  final String message;
  final List<String> errors;
  final RideRequestData data;
  final Notes notes;

  RideRequestModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      status: json['status'],
      message: json['message'],
      errors: List<String>.from(json['errors']),
      data: RideRequestData.fromJson(json['data']),
      notes: Notes.fromJson(json['notes']),
    );
  }
}

class RideRequestData {
  final Request request;

  RideRequestData({required this.request});

  factory RideRequestData.fromJson(Map<String, dynamic> json) {
    return RideRequestData(
      request: Request.fromJson(json['Request']),
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
  var price;
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
      distance: json['distance'],
      price: json['price'],
      stops: List<dynamic>.from(json['stops']),
    );
  }
}

class Notes {
  final List<String> vehicleTypes;

  Notes({required this.vehicleTypes});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      vehicleTypes: List<String>.from(json['Vehicle Types']),
    );
  }
}
