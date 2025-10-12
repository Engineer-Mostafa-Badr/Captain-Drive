class CaptainMakeOfferModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final OfferData? data;
  final List<dynamic> notes;

  CaptainMakeOfferModel({
    required this.status,
    required this.message,
    required this.errors,
    this.data,
    required this.notes,
  });

  factory CaptainMakeOfferModel.fromJson(Map<String, dynamic> json) {
    return CaptainMakeOfferModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? OfferData.fromJson(json['data'])
          : null,
      notes: json['notes'] ?? [],
    );
  }
}

class OfferData {
  final Offer? offer;

  OfferData({this.offer});

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      offer: json['offer'] != null ? Offer.fromJson(json['offer']) : null,
    );
  }
}

class Offer {
  final int driverId;
  final int requestId;
  final num price;
  final String updatedAt;
  final String createdAt;
  final int id;

  Offer({
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}
