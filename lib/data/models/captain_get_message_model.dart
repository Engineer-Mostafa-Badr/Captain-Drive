class CaptainGetMessageModel {
  final bool status;
  final String message;
  final List<dynamic> errors;
  final Data? data;
  final Notes notes;

  CaptainGetMessageModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory CaptainGetMessageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    Data? messageData;

    if (data is Map<String, dynamic>) {
      messageData = Data.fromJson(data);
    } else {
      // Handle case where 'data' is not a Map (e.g., when it's a list or null)
      messageData = null; // You can set to null or create an empty instance
    }
    return CaptainGetMessageModel(
      status: json['status'],
      message: json['message'],
      errors: List<dynamic>.from(json['errors']),
      data: messageData,
      notes: Notes.fromJson(json['notes']),
    );
  }
}

class Data {
  final String message;
  final int status;

  Data({
    required this.message,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
    };
  }
}

class Notes {
  final StatusNotes statusNotes;
  final String note0;

  Notes({
    required this.statusNotes,
    required this.note0,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      statusNotes: StatusNotes.fromJson(json['status-notes']),
      note0: json['0'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status-notes': statusNotes.toJson(),
      '0': note0,
    };
  }
}

class StatusNotes {
  final String status2;
  final String status3;
  final String status4;

  StatusNotes({
    required this.status2,
    required this.status3,
    required this.status4,
  });

  factory StatusNotes.fromJson(Map<String, dynamic> json) {
    return StatusNotes(
      status2: json['2'],
      status3: json['3'],
      status4: json['4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '2': status2,
      '3': status3,
      '4': status4,
    };
  }
}
