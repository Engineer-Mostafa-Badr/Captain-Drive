import '../../domain/entities/passenger_entity.dart';

class PassengerLoginModel extends PassengerEntity {
  PassengerLoginModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
  });

  factory PassengerLoginModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']?['user'] ?? json['user'] ?? {};
    return PassengerLoginModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'] ?? '',
      token: json['data']?['token'] ?? '',
    );
  }
}
