// lib/features/auth/passenger/domain/params/passenger_signup_params.dart
class PassengerSignUpParams {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const PassengerSignUpParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}
