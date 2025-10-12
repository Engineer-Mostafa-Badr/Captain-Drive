class GetPriceModel {
  final bool? status;
  final String? message;
  final List<dynamic>? errors;
  final ProfitsData? data;
  final List<dynamic>? notes;

  GetPriceModel({
    this.status,
    this.message,
    this.errors,
    this.data,
    this.notes,
  });

  factory GetPriceModel.fromJson(Map<String, dynamic> json) {
    return GetPriceModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      errors: json['errors'] ?? [],
      data: json['data'] != null ? ProfitsData.fromJson(json['data']) : null,
      notes: json['notes'] ?? [],
    );
  }
}

class ProfitsData {
  final List<Profit>? profits;

  ProfitsData({this.profits});

  factory ProfitsData.fromJson(Map<String, dynamic> json) {
    return ProfitsData(
      profits: (json['profits'] as List?)
          ?.map((profit) => Profit.fromJson(profit))
          .toList(),
    );
  }
}

class Profit {
  final int? id;
  final int? vehicleType;
  final int? perKilo;
  final int? percentage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profit({
    this.id,
    this.vehicleType,
    this.perKilo,
    this.percentage,
    this.createdAt,
    this.updatedAt,
  });

  factory Profit.fromJson(Map<String, dynamic> json) {
    return Profit(
      id: json['id'] as int?,
      vehicleType: json['vehicle_type'] as int?,
      perKilo: json['per_kilo'] as int?,
      percentage: json['percentage'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
