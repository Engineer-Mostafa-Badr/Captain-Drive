class CaptainMakeReservationOfferModel {
  final bool status;
  final String message;
  final List<String> errors;
  final ReservationOfferData? data;
  final List<String> notes;

  CaptainMakeReservationOfferModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory CaptainMakeReservationOfferModel.fromJson(Map<String, dynamic> json) {
    return CaptainMakeReservationOfferModel(
      status: json['status'],
      message: json['message'],
      errors: List<String>.from(json['errors'] ?? []),
      data: json['data'] != null
          ? (json['data'] is Map<String, dynamic>
              ? ReservationOfferData.fromJson(json['data'])
              : json['data'] is List
                  ? ReservationOfferData.fromJsonList(json['data'])
                  : null)
          : null,
      notes: List<String>.from(json['notes'] ?? []),
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

class ReservationOfferData {
  final ReservationOffer? reservationOffer;
  final List<ReservationOffer>? reservationOffers;

  ReservationOfferData({
    this.reservationOffer,
    this.reservationOffers,
  });

  factory ReservationOfferData.fromJson(Map<String, dynamic> json) {
    return ReservationOfferData(
      reservationOffer: json['reservation_offer'] != null
          ? ReservationOffer.fromJson(json['reservation_offer'])
          : null,
      reservationOffers: json['reservation_offers'] != null
          ? List<ReservationOffer>.from(json['reservation_offers']
              .map((x) => ReservationOffer.fromJson(x)))
          : null,
    );
  }

  factory ReservationOfferData.fromJsonList(List<dynamic> json) {
    return ReservationOfferData(
      reservationOffers: List<ReservationOffer>.from(
          json.map((x) => ReservationOffer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservation_offer': reservationOffer?.toJson(),
      'reservation_offers': reservationOffers?.map((x) => x.toJson()).toList(),
    };
  }
}

class ReservationOffer {
  final int driverId;
  final int requestId;
  final int price;
  final String updatedAt;
  final String createdAt;
  final int id;

  ReservationOffer({
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory ReservationOffer.fromJson(Map<String, dynamic> json) {
    return ReservationOffer(
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'request_id': requestId,
      'price': price,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
