class CaptainForgetPasswordModel {
  late bool status;
  late String message;

  CaptainForgetPasswordModel({
    required this.status,
    required this.message,
  });

  CaptainForgetPasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
