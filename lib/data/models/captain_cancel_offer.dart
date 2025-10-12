class CaptainCancelOfferModel {
  late bool status;
  late String message;

  CaptainCancelOfferModel({
    required this.status,
    required this.message,
  });

  CaptainCancelOfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
