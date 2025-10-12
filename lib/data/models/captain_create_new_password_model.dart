class CaptainCreateNewPasswordModel {
  late bool status;
  late String message;

  CaptainCreateNewPasswordModel({
    required this.status,
    required this.message,
  });

  CaptainCreateNewPasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
