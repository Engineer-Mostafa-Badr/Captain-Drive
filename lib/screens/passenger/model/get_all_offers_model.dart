class GetAllOffersModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final OffersData? data; // Make OffersData nullable to handle null case
  final VehicleNotes notes;

  GetAllOffersModel({
    required this.status,
    required this.message,
    required this.errors,
    this.data, // Nullable
    required this.notes,
  });

  factory GetAllOffersModel.fromJson(Map<String, dynamic> json) {
    return GetAllOffersModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: json['data'] is Map<String, dynamic>
          ? OffersData.fromJson(json['data'])
          : null, // Handle 'data' as a Map or null
      notes: VehicleNotes.fromJson(json['notes']),
    );
  }
}

class OffersData {
  final List<Offer> offers;

  OffersData({required this.offers});

  factory OffersData.fromJson(Map<String, dynamic> json) {
    return OffersData(
      offers: (json['offers'] as List).map((e) => Offer.fromJson(e)).toList(),
    );
  }
}

class Offer {
  final int id;
  final int driverId;
  final int requestId;
  final double price;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Driver driver;

  Offer({
    required this.id,
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.driver,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      driver: Driver.fromJson(json['driver']),
    );
  }
}

class Driver {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String addPhone;
  final String nationalId;
  final String picture;
  final String socialStatus;
  final String gender;
  final String status;
  final String lng;
  final String lat;
  final String superKey;
  final String uniqueId;
  String? rate;
  final bool isEmailVerified;
  final bool isApproved;
  final Vehicle vehicle;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.addPhone,
    required this.nationalId,
    required this.picture,
    required this.socialStatus,
    required this.gender,
    required this.status,
    required this.lng,
    required this.lat,
    required this.superKey,
    required this.uniqueId,
    required this.rate,
    required this.isEmailVerified,
    required this.isApproved,
    required this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      addPhone: json['add_phone'],
      nationalId: json['national_id'],
      picture: json['picture'],
      socialStatus: json['social_status'],
      gender: json['gender'],
      status: json['status'],
      lng: json['lng'],
      lat: json['lat'],
      superKey: json['super_key'],
      uniqueId: json['unique_id'],
      rate: json['rate'],
      isEmailVerified: json['is_email_verified'] == 1,
      isApproved: json['is_approved'] == 1,
      vehicle: Vehicle.fromJson(json['vehicle']),
    );
  }
}

class Vehicle {
  final int id;
  final int driverId;
  final int type;
  final String model;
  final String color;
  final String platesNumber;

  Vehicle({
    required this.id,
    required this.driverId,
    required this.type,
    required this.model,
    required this.color,
    required this.platesNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      driverId: json['driver_id'],
      type: json['type'],
      model: json['model'],
      color: json['color'],
      platesNumber: json['plates_number'],
    );
  }
}

class VehicleNotes {
  final List<String> vehicleTypes;

  VehicleNotes({required this.vehicleTypes});

  factory VehicleNotes.fromJson(Map<String, dynamic> json) {
    return VehicleNotes(
      vehicleTypes: List<String>.from(json['Vehicle Types']),
    );
  }
}

// Updated method to handle the API response and errors
