import '../../domain/entities/driver_entity.dart';

class DriverLoginModel extends DriverEntity {
  DriverLoginModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
  });

  factory DriverLoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};

    return DriverLoginModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'] ?? '',
      token: data['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
    };
  }
}
