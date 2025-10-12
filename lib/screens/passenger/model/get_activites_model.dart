class GetActivitiesModel {
  bool status;
  String message;
  List<dynamic> errors;
  List<RideData> data;
  Notes notes;

  GetActivitiesModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.data,
    required this.notes,
  });

  factory GetActivitiesModel.fromJson(Map<String, dynamic> json) {
    return GetActivitiesModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'],
      data: List<RideData>.from(json['data'].map((x) => RideData.fromJson(x))),
      notes: Notes.fromJson(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'errors': errors,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'notes': notes.toJson(),
    };
  }
}

class RideData {
  int currentPage;
  List<ActivityData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int to;
  int total;

  RideData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      currentPage: json['current_page'],
      data: List<ActivityData>.from(
          json['data'].map((x) => ActivityData.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((x) => Link.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': List<dynamic>.from(links.map((x) => x.toJson())),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class ActivityData {
  int id;
  int offerId;
  String createdAt;
  String updatedAt;
  String status;
  dynamic rate;
  dynamic review;
  Offer offer;

  ActivityData({
    required this.id,
    required this.offerId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.rate,
    this.review,
    required this.offer,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      id: json['id'],
      offerId: json['offer_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      rate: json['rate'],
      review: json['review'],
      offer: Offer.fromJson(json['offer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer_id': offerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'rate': rate,
      'review': review,
      'offer': offer.toJson(),
    };
  }
}

class Offer {
  int id;
  int driverId;
  int requestId;
  int price;
  String status;
  String createdAt;
  String updatedAt;
  Request request;

  Offer({
    required this.id,
    required this.driverId,
    required this.requestId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driver_id'],
      requestId: json['request_id'],
      price: json['price'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      request: Request.fromJson(json['request']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'request_id': requestId,
      'price': price,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'request': request.toJson(),
    };
  }
}

class Request {
  int id;
  int userId;
  String stLng;
  String stLat;
  String enLng;
  String enLat;
  String status;
  String createdAt;
  String updatedAt;
  int vehicle;
  String stLocation;
  String enLocation;
  String type;
  dynamic time;
  double distance;
  double price;
  List<dynamic> stops;

  Request({
    required this.id,
    required this.userId,
    required this.stLng,
    required this.stLat,
    required this.enLng,
    required this.enLat,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicle,
    required this.stLocation,
    required this.enLocation,
    required this.type,
    this.time,
    required this.distance,
    required this.price,
    required this.stops,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      userId: json['user_id'],
      stLng: json['st_lng'],
      stLat: json['st_lat'],
      enLng: json['en_lng'],
      enLat: json['en_lat'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      vehicle: json['vehicle'],
      stLocation: json['st_location'],
      enLocation: json['en_location'],
      type: json['type'],
      time: json['time'],
      distance: json['distance'].toDouble(),
      price: json['price'].toDouble(),
      stops: List<dynamic>.from(json['stops']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'st_lng': stLng,
      'st_lat': stLat,
      'en_lng': enLng,
      'en_lat': enLat,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'vehicle': vehicle,
      'st_location': stLocation,
      'en_location': enLocation,
      'type': type,
      'time': time,
      'distance': distance,
      'price': price,
      'stops': stops,
    };
  }
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}

class Notes {
  List<String> vehicleTypes;

  Notes({
    required this.vehicleTypes,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      vehicleTypes: List<String>.from(json['Vehicle Types']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Vehicle Types': vehicleTypes,
    };
  }
}
