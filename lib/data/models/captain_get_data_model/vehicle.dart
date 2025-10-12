class Vehicle {
  int? id;
  int? driverId;
  int? type;
  String? model;
  String? color;
  String? platesNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  Vehicle({
    this.id,
    this.driverId,
    this.type,
    this.model,
    this.color,
    this.platesNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int?,
      driverId: json['driver_id'] as int?,
      type: json['type'] as int?,
      model: json['model'] as String?,
      color: json['color'] as String?,
      platesNumber: json['plates_number'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'type': type,
      'model': model,
      'color': color,
      'plates_number': platesNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
