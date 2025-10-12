class RegisterGoogleModel {
  late bool status;
  late String message;
  UserData? data;

  RegisterGoogleModel({
    required this.status,
    required this.message,
    this.data,
  });

  RegisterGoogleModel.fromJson(Map<String, dynamic> json) {
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
  late User? user;
  late String? token;

  UserData({
    required this.user,
    required this.token,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null && json['user'] is Map<String, dynamic>
        ? User.fromJson(json['user'])
        : null;
    token = json['token'];
  }
}

class User {
  late String name;
  late String email;
  late String? token;

  User({required this.name, required this.email, required this.token});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    token = json['token'];
  }
}
