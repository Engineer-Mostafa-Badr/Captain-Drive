class CameraModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final Data data;
  final List<dynamic> notes;

  CameraModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      status: json['status'],
      message: json['message'] ?? '',
      errors: List<dynamic>.from(json['errors']),
      data: Data.fromJson(json['data']),
      notes: List<dynamic>.from(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'errors': errors,
      'data': data.toJson(),
      'notes': notes,
    };
  }
}

class Data {
  final Video video;

  Data({required this.video});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      video: Video.fromJson(json['video']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video.toJson(),
    };
  }
}

class Video {
  final String rideId;
  final String? title;
  final String? notes;
  final String path;
  final String updatedAt;
  final String createdAt;
  final int id;

  Video({
    required this.rideId,
    this.title,
    this.notes,
    required this.path,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      rideId: json['ride_id'],
      title: json['title'],
      notes: json['notes'],
      path: json['path'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'title': title,
      'notes': notes,
      'path': path,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
