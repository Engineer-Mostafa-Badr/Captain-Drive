class CaptainGetOfferModel {
  bool status;
  String message;
  List<dynamic> errors;
  Data? data;
  List<dynamic> notes;

  CaptainGetOfferModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory CaptainGetOfferModel.fromJson(Map<String, dynamic> json) {
    // Check the type of 'data' to ensure it is a Map before parsing.
    var data = json['data'];
    Data? parsedData;

    if (data is Map<String, dynamic>) {
      parsedData = Data.fromJson(data);
    } else {
      parsedData = null; // Set to null if data is not a Map.
    }

    return CaptainGetOfferModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'] ?? [],
      data: parsedData,
      notes: json['notes'] ?? [],
    );
  }
}

class Data {
  List<Offer> offers;

  Data({required this.offers});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      offers: List<Offer>.from(json['offers'].map((x) => Offer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': List<dynamic>.from(offers.map((x) => x.toJson())),
    };
  }
}

class Offer {
  int id;
  int driverId;
  int requestId;
  num price;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Request request;

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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      request: Request.fromJson(json['request']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'request_id': requestId,
      'price': price,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'request': request.toJson(),
    };
  }
}

class Request {
  int id;
  int userId;
  String stLng;
  String stLat;
  String enLng;
  String enLat;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int vehicle;
  String stLocation;
  String enLocation;
  String type;
  dynamic time;
  double distance;
  num price;
  List<Stop> stops;

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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      vehicle: json['vehicle'],
      stLocation: json['st_location'],
      enLocation: json['en_location'],
      type: json['type'],
      time: json['time'],
      distance: json['distance'].toDouble(),
      price: json['price'],
      stops: List<Stop>.from(json['stops'].map((x) => Stop.fromJson(x))),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'vehicle': vehicle,
      'st_location': stLocation,
      'en_location': enLocation,
      'type': type,
      'time': time,
      'distance': distance,
      'price': price,
      'stops': List<dynamic>.from(stops.map((x) => x.toJson())),
    };
  }
}

class Stop {
  int id;
  int rideRequestId;
  String stopLocation;
  String lng;
  String lat;
  DateTime createdAt;
  DateTime updatedAt;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_request_id': rideRequestId,
      'stop_location': stopLocation,
      'lng': lng,
      'lat': lat,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
