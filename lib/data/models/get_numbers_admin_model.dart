class GetNumbersAdminModel {
  bool status;
  String message;
  List<dynamic> errors;
  Data data;
  Notes notes;

  GetNumbersAdminModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory GetNumbersAdminModel.fromJson(Map<String, dynamic> json) {
    return GetNumbersAdminModel(
      status: json['status'],
      message: json['message'],
      errors: List<dynamic>.from(json['errors']),
      data: Data.fromJson(json['data']),
      notes: Notes.fromJson(json['notes']),
    );
  }
}

class Data {
  List<Number> numbers;

  Data({required this.numbers});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      numbers:
          List<Number>.from(json['numbers'].map((x) => Number.fromJson(x))),
    );
  }
}

class Number {
  int id;
  String name;
  String reference;
  dynamic notes;
  DateTime createdAt;
  DateTime updatedAt;
  int type;

  Number({
    required this.id,
    required this.name,
    required this.reference,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  factory Number.fromJson(Map<String, dynamic> json) {
    return Number(
      id: json['id'],
      name: json['name'],
      reference: json['reference'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      type: json['type'],
    );
  }
}

class Notes {
  Map<String, String> typeNotes;
  String otherNotes;

  Notes({
    required this.typeNotes,
    required this.otherNotes,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      typeNotes: Map<String, String>.from(json['type-notes']),
      otherNotes: json['0'],
    );
  }
}
