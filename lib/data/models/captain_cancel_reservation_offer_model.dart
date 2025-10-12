class CaptainCancelReservationOfferModel {
  late bool status;
  late String message;

  CaptainCancelReservationOfferModel({
    required this.status,
    required this.message,
  });

  CaptainCancelReservationOfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
