class CaptainSignUpModel {
  late bool status;
  late String message;
  UserData? data;

  CaptainSignUpModel({
    required this.status,
    required this.message,
    this.data,
  });

  CaptainSignUpModel.fromJson(Map<String, dynamic> json) {
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
  late Vehicle? vehicle;
  late String? token;

  UserData({
    required this.user,
    required this.token,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    user = json['driver'] != null && json['driver'] is Map<String, dynamic>
        ? User.fromJson(json['driver'])
        : null;

    vehicle = json['vehicle'] != null && json['vehicle'] is Map<String, dynamic>
        ? Vehicle.fromJson(json['vehicle'])
        : null;

    token = json['token'];
  }
}

class User {
  late String name;
  late String email;
  late String phone;
  late String addPhone;
  late String nationalId;
  late String status;
  late String gender;
  late String superKey;
  late num uniqueId;
  late String picture;
  late String password;
  late int id;
  late String? token;

  User(
      {required this.name,
      required this.email,
      required this.phone,
      required this.addPhone,
      required this.nationalId,
      required this.status,
      required this.gender,
      required this.superKey,
      required this.uniqueId,
      required this.picture,
      required this.password,
      required this.id,
      required this.token});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    addPhone = json['add_phone'];
    nationalId = json['national_id'];
    status = json['social_status'];
    gender = json['gender'];
    superKey = json['super_key'];
    uniqueId = json['unique_id'];
    picture = json['picture'];
    password = json['password'];
    id = json['id'];
    token = json['token'];
  }
}

class Vehicle {
  late int driverId;
  late String type;
  late String model;
  late String color;
  late String platesNumber;
  late int id;

  Vehicle({
    required this.driverId,
    required this.type,
    required this.model,
    required this.color,
    required this.platesNumber,
    required this.id,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    type = json['type'];
    model = json['model'];
    color = json['color'];
    platesNumber = json['plates_number'];
    id = json['id'];
  }
}
