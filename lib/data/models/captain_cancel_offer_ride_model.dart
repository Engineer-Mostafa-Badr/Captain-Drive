class CaptainCancelRideOfferModel {
  late bool status;
  late String message;

  CaptainCancelRideOfferModel({
    required this.status,
    required this.message,
  });

  CaptainCancelRideOfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
