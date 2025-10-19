import 'dart:io';

class DriverSignUpParams {
  final String name;
  final String email;
  final String phone;
  final String addPhone;
  final String status;
  final String nationalId;
  final String gender;
  final String password;
  final String confirmPassword;
  final File picture;
  final File nationalFront;
  final File nationalBack;
  final File driverLFront;
  final File driverLBack;
  final File vehicleFront;
  final File vehicleBack;
  final File criminalRecord;
  final String type;
  final String model;
  final String color;
  final String platesNumber;

  const DriverSignUpParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.addPhone,
    required this.status,
    required this.nationalId,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    required this.picture,
    required this.nationalFront,
    required this.nationalBack,
    required this.driverLFront,
    required this.driverLBack,
    required this.vehicleFront,
    required this.vehicleBack,
    required this.criminalRecord,
    required this.type,
    required this.model,
    required this.color,
    required this.platesNumber,
  });
}
