import 'data.dart';

class CaptainGetDataModel {
  bool? status;
  String? message;
  List<dynamic>? errors;
  Data? data;
  List<dynamic>? notes;

  CaptainGetDataModel({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.notes,
  });

  factory CaptainGetDataModel.fromJson(Map<String, dynamic> json) {
    return CaptainGetDataModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      errors: json['errors'] as List<dynamic>?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      notes: json['notes'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'errors': errors,
      'data': data?.toJson(),
      'notes': notes,
    };
  }
}
