class ChangePasswordModel {
  late bool status;
  late String message;
  // List<Data>? data;

  ChangePasswordModel({
    required this.status,
    required this.message,
    // this.data,
  });

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['data'] != null && json['data'] is List) {
    //   data = List<Data>.from(json['data'].map((x) => Data.fromJson(x)));
    // } else {
    //   data = null;
    // }
  }
}

// class Data {
//   late String recipientName;
//   late String recipientPhone;
//   late String recipientAddress;
//   late int subTotal;
//   late String totalSellPrice;
//   late String userType;
//   late int userId;
//   late int status;
//   late String yourName;
//   late String yourPhone;
//   String? yourSecPhone='';
//   late String recipientGovernorate;
//   String? facebook='';
//   String? webPage='';
//   String? notes='';
//   late String updatedAt;
//   late String createdAt;
//   late int id;
//
//   Data({
//     required this.recipientName,
//     required this.recipientPhone,
//     required this.recipientAddress,
//     required this.subTotal,
//     required this.totalSellPrice,
//     required this.userType,
//     required this.userId,
//     required this.status,
//     required this.yourName,
//     required this.yourPhone,
//     this.yourSecPhone,
//     required this.recipientGovernorate,
//     this.facebook,
//     this.webPage,
//     this.notes,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     recipientName = json['recipient_name'];
//     recipientPhone = json['recipient_phone'];
//     recipientAddress = json['recipient_address'];
//     subTotal = json['sub_total'];
//     totalSellPrice = json['total_sell_price'];
//     userType = json['user_type'];
//     userId = json['user_id'];
//     status = json['status'];
//     yourName = json['your_name'];
//     yourPhone = json['your_phone'];
//     yourSecPhone = json['your_sec_phone'];
//     recipientGovernorate = json['recipient_governorate'];
//     facebook = json['facebook'];
//     webPage = json['web_page'];
//     notes = json['notes'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     id = json['id'];
//   }
// }
