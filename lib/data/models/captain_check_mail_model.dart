class CaptainCheckMailModel {
  late bool status;
  late String message;

  CaptainCheckMailModel({
    required this.status,
    required this.message,
  });

  CaptainCheckMailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
