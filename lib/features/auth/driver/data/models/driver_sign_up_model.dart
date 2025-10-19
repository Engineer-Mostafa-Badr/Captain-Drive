import '../../domain/entities/driver_entity.dart';

class DriverSignUpModel extends DriverEntity {
  DriverSignUpModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
  });

  factory DriverSignUpModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']?['user'] ?? json['user'] ?? {};
    final token = json['data']?['token'] ?? json['token'] ?? '';
    return DriverSignUpModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone']?.toString() ?? '',
      token: token,
    );
  }
}
