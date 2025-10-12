class RemoveDriverModel {
  late bool status;
  late String message;

  RemoveDriverModel({
    required this.status,
    required this.message,
  });

  RemoveDriverModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
