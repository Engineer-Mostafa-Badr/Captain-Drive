import 'user.dart';

class Data {
  User? user;

  Data({this.user});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
    };
  }
}
