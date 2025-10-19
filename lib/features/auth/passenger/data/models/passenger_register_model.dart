import '../../domain/entities/passenger_entity.dart';

class PassengerRegisterModel extends PassengerEntity {
  PassengerRegisterModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
  });

  factory PassengerRegisterModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']?['user'] ?? json['user'] ?? {};
    return PassengerRegisterModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'] ?? '',
      token: json['data']?['token'] ?? '',
    );
  }
}
