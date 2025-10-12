class CaptainLoginModel {
  late bool status;
  late String message;
  UserData? data;

  CaptainLoginModel({
    required this.status,
    required this.message,
    this.data,
  });

  CaptainLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // Check if 'data' is a Map and not null
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = UserData.fromJson(json['data']);
    } else {
      data = null;
    }
  }
}

class UserData {
  late String? token;

  UserData({
    required this.token,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}

class User {
  late String? token;

  User({required this.token});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}
