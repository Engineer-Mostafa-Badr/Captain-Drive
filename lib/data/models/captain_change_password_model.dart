class CaptainChangePasswordModel {
  late bool status;
  late String message;

  CaptainChangePasswordModel({
    required this.status,
    required this.message,
  });

  CaptainChangePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
