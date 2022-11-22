class ClientBookingModel {
  ClientBookingModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<DataResponse> data;

  ClientBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        List.from(json['data']).map((e) => DataResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DataResponse {
  DataResponse({
    required this.id,
    required this.title,
    required this.uid,
    required this.bookingDate,
    required this.arrivalDate,
    required this.bookingType,
    required this.from,
    required this.to,
    this.shipmentCompany,
    this.bookingItem,
    required this.status,
    required this.accepted,
    required this.rejected,
    required this.pickupReview,
    required this.scheduleId,
    required this.receptionistInfo,
    // required this.clientInfoData,
    this.transactionId,
    required this.totalAmount,
    this.cardType,
    required this.createdAt,
    required this.updatedAt,
    required this.item,
    required this.client,
    required this.arrivalID,
    required this.departureID,
    required this.pickupagentID,
    required this.receptionistID,
  });
  late final int id;
  late final String title;
  late final String pickupagentID;
  late final int receptionistID;
  late final List<ArrivalID> arrivalID;
  late final List<DepartureID> departureID;
  late final int uid;
  late final String bookingDate;
  late final String arrivalDate;
  late final String bookingType;
  late final String from;
  late final String to;
  late final String? shipmentCompany;
  late final Null bookingItem;
  late final String status;
  late final int accepted;
  late final int rejected;
  late final List<PickupReview> pickupReview;
  late final String scheduleId;
  late final List<ReceptionistInfo> receptionistInfo;
  // late final List<ClientInfoData> clientInfoData;

  late final String? transactionId;
  late final String totalAmount;
  late final String? cardType;
  late final String createdAt;
  late final String updatedAt;
  late final List<Item> item;
  late final List<Client> client;

  DataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupagentID = json['pickupagent_id'] ?? "0";
    receptionistID = json['receptionist_id'];
    arrivalID =
        List.from(json['arrival']).map((e) => ArrivalID.fromJson(e)).toList();

    departureID = List.from(json['departure'])
        .map((e) => DepartureID.fromJson(e))
        .toList();

    title = json['title'];
    uid = json['uid'];
    bookingDate = json['booking_date'];
    arrivalDate = json['arrival_date'];
    bookingType = json['booking_type'];
    from = json['from'];
    to = json['to'];
    shipmentCompany = null;
    bookingItem = null;
    status = json['status'];
    accepted = json['accepted'];
    rejected = json['rejected'];
    pickupReview = List.from(json['pickup_review'])
        .map((e) => PickupReview.fromJson(e))
        .toList();
    scheduleId = json['schedule_id'];
    receptionistInfo = List.from(json['receptionist_info'])
        .map((e) => ReceptionistInfo.fromJson(e))
        .toList();
    // clientInfoData = List.from(json['client'])
    //     .map((e) => ClientInfoData.fromJson(e))
    //     .toList();
    transactionId = null;
    totalAmount = json['total_amount'];
    cardType = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    item = List.from(json['item']).map((e) => Item.fromJson(e)).toList();
    client = List.from(json['client']).map((e) => Client.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['pickupagent_id'] = pickupagentID;
    _data['receptionist_id'] = receptionistID;
    _data['arrival'] = arrivalID.map((e) => e.toJson()).toList();
    _data['departure'] = departureID.map((e) => e.toJson()).toList();

    _data['title'] = title;
    _data['uid'] = uid;
    _data['booking_date'] = bookingDate;
    _data['arrival_date'] = arrivalDate;
    _data['booking_type'] = bookingType;
    _data['from'] = from;
    _data['to'] = to;
    _data['shipment_company'] = shipmentCompany;
    _data['booking_item'] = bookingItem;
    _data['status'] = status;
    _data['accepted'] = accepted;
    _data['rejected'] = rejected;
    _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
    _data['schedule_id'] = scheduleId;
    _data['receptionist_info'] =
        receptionistInfo.map((e) => e.toJson()).toList();

    // _data['client'] = ClientInfoData.map((e) => e.toJson()).toList();
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['item'] = item.map((e) => e.toJson()).toList();
    _data['client'] = client.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ArrivalID {
  ArrivalID({
    required this.id,
  });
  late final String id;

  ArrivalID.fromJson(Map<String, dynamic> json) {
    id = json['destination_warehouse'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['destination_warehouse'] = id;
    return _data;
  }
}

class DepartureID {
  DepartureID({
    required this.id,
  });
  late final String id;

  DepartureID.fromJson(Map<String, dynamic> json) {
    id = json['departure_warehouse'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['destination_warehouse'] = id;
    return _data;
  }
}

class PickupReview {
  PickupReview({
    required this.pickupType,
    required this.pickupLocation,
    required this.pickupDate,
    this.pickupTime,
    this.pickupDistance,
    this.pickupEstimate,
  });
  late final String pickupType;
  late final String pickupLocation;
  late final String pickupDate;
  late final String? pickupTime;
  late final String? pickupDistance;
  late final String? pickupEstimate;

  PickupReview.fromJson(Map<String, dynamic> json) {
    pickupType = json['pickup_type'];
    pickupLocation = json['pickup_location'];
    pickupDate = json['pickup_date'];
    pickupTime = null;
    pickupDistance = null;
    pickupEstimate = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pickup_type'] = pickupType;
    _data['pickup_location'] = pickupLocation;
    _data['pickup_date'] = pickupDate;
    _data['pickup_time'] = pickupTime;
    _data['pickup_distance'] = pickupDistance;
    _data['pickup_estimate'] = pickupEstimate;
    return _data;
  }
}

class ReceptionistInfo {
  ReceptionistInfo({
    required this.receptionistName,
    required this.receptionistEmail,
    required this.receptionistPhone,
    required this.receptionistAddress,
  });
  late final String? receptionistName;
  late final String? receptionistEmail;
  late final String? receptionistPhone;
  late final String? receptionistAddress;

  ReceptionistInfo.fromJson(Map<String, dynamic> json) {
    receptionistName = json['receptionist_name'] ?? "";
    receptionistEmail = json['receptionist_email'] ?? "";
    receptionistPhone = json['receptionist_phone'] ?? "";
    receptionistAddress = json['receptionist_address'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['receptionist_name'] = receptionistName;
    _data['receptionist_email'] = receptionistEmail;
    _data['receptionist_phone'] = receptionistPhone;
    _data['receptionist_address'] = receptionistAddress;
    return _data;
  }
}

// class ClientInfoData {
//   ClientInfoData({
//     required this.name,
//     required this.lname,
//     required this.email,
//     required this.phone,
//     required this.address,
//   });
//   late final String name;
//   late final String? lname;
//   late final String? email;
//   late final String? phone;

//   late final String? address;

//   ClientInfoData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     lname = json['lname'];
//     phone = json['phone'];
//     email = json['email'] ?? "";
//     address = json['address'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['name'] = name;
//     _data['lname'] = lname;

//     _data['phone'] = phone;
//     _data['email'] = email;
//     _data['address'] = address;
//     return _data;
//   }
// }

class Item {
  Item({
    required this.id,
    required this.uid,
    required this.category,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.description,
    required this.bookingId,
    required this.scheduleId,
  });
  late final int id;
  late final int uid;
  late final String category;
  late final String itemName;
  late final String itemImage;
  late final int quantity;
  late final String description;
  late final int bookingId;
  late final int scheduleId;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    category = json['category'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    quantity = json['quantity'];
    description = json['description'];
    bookingId = json['booking_id'];
    scheduleId = json['schedule_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['category'] = category;
    _data['item_name'] = itemName;
    _data['item_image'] = itemImage;
    _data['quantity'] = quantity;
    _data['description'] = description;
    _data['booking_id'] = bookingId;
    _data['schedule_id'] = scheduleId;
    return _data;
  }
}

class Client {
  Client({
    required this.id,
    required this.name,
    this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    this.username,
    this.countryCode,
    this.country,
    this.address,
    this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    this.about_me,
    this.language,
    required this.clientId,
    required this.type,
    this.provider,
    this.otp,
  });
  late final int id;
  late final String name;
  late final String? lname;
  late final String email;
  late final String roles;
  late final String? phone;
  late final String? username;
  late final String? countryCode;
  late final String? country;
  late final String? address;
  late final String? profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final String? status;
  late final String? about_me;
  late final String? language;
  late final int clientId;
  late final String? type;
  late final Null provider;
  late final String? otp;

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = null;
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = null;
    countryCode = null;
    country = json['country'] ?? "";
    address = json['address'] ?? "NA";
    profileimage = json['profileimage'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] ?? "NA";
    about_me = json['about_me'] ?? "NA";
    language = json['language'] ?? "NA";
    clientId = json['client_id'];
    type = json['type'];
    provider = null;
    otp = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['roles'] = roles;
    _data['phone'] = phone;
    _data['username'] = username;
    _data['country_code'] = countryCode;
    _data['country'] = country;
    _data['address'] = address;
    _data['profileimage'] = profileimage;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['status'] = status;
    _data['about_me'] = about_me;
    _data['language'] = language;
    _data['client_id'] = clientId;
    _data['type'] = type;
    _data['provider'] = provider;
    _data['otp'] = otp;
    return _data;
  }
}
