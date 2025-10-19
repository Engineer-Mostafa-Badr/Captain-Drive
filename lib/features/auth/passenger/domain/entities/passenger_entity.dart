// lib/features/auth/passenger/domain/entities/passenger_entity.dart
class PassengerEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String token;

  PassengerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
  });
}
