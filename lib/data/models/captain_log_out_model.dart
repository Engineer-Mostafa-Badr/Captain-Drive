class CaptainLogOutModel {
  late bool status;
  late String message;

  CaptainLogOutModel({
    required this.status,
    required this.message,
  });

  CaptainLogOutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
