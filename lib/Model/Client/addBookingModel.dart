class AddBookingModel {
  AddBookingModel({
    required this.status,
    required this.message,
    required this.paymentLink,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final String paymentLink;

  late final List<Data> data;

  AddBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] == null ? "" : json['status'];
    message = json['message'];
    paymentLink = json['payment_link'];

    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.uid,
    required this.title,
    required this.bookingDate,
    required this.arrivalDate,
    required this.bookingType,
    required this.from,
    required this.to,
    required this.shipmentCompany,
    required this.status,
    required this.scheduleId,
    required this.transactionId,
    required this.cardType,
    required this.pickupReview,
    required this.receptionistInfo,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.itemType,
  });
  late final int uid;
  late final String title;
  late final String bookingDate;
  late final String arrivalDate;
  late final String bookingType;
  late final String from;
  late final String to;
  late final String shipmentCompany;
  late final String status;
  late final String scheduleId;
  late final String transactionId;
  late final String cardType;
  late final List<PickupReview> pickupReview;
  late final List<ReceptionistInfo> receptionistInfo;
  late final String updatedAt;
  late final String createdAt;
  late final int id;
  late final List<ItemType> itemType;

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    title = json['title'];
    bookingDate = json['booking_date'];
    arrivalDate = json['arrival_date'];
    bookingType = json['booking_type'];
    from = json['from'];
    to = json['to'];
    shipmentCompany =
        json['shipment_company'] == null ? "" : json['shipment_company'];
    status = json['status'];
    scheduleId = json['schedule_id'];
    transactionId =
        json['transaction_id'] == null ? "" : json['transaction_id'];
    cardType = json['card_type'] == null ? "" : json['card_type'];
    pickupReview = List.from(json['pickup_review'])
        .map((e) => PickupReview.fromJson(e))
        .toList();
    receptionistInfo = List.from(json['receptionist_info'])
        .map((e) => ReceptionistInfo.fromJson(e))
        .toList();
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    itemType =
        List.from(json['item_type']).map((e) => ItemType.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['title'] = title;
    _data['booking_date'] = bookingDate;
    _data['arrival_date'] = arrivalDate;
    _data['booking_type'] = bookingType;
    _data['from'] = from;
    _data['to'] = to;
    _data['shipment_company'] = shipmentCompany;
    _data['status'] = status;
    _data['schedule_id'] = scheduleId;
    _data['transaction_id'] = transactionId;
    _data['card_type'] = cardType;
    _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
    _data['receptionist_info'] =
        receptionistInfo.map((e) => e.toJson()).toList();
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    _data['item_type'] = itemType.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PickupReview {
  PickupReview({
    required this.pickupType,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupDistance,
    required this.pickupEstimate,
  });
  late final String pickupType;
  late final String pickupLocation;
  late final String pickupDate;
  late final String pickupTime;
  late final String pickupDistance;
  late final String pickupEstimate;

  PickupReview.fromJson(Map<String, dynamic> json) {
    pickupType = json['pickup_type'];
    pickupLocation = json['pickup_location'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
    pickupDistance =
        json['pickup_distance'] == null ? "" : json['pickup_distance'];
    pickupEstimate =
        json['pickup_estimate'] == null ? "" : json['pickup_estimate'];
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
    required this.receptionistCountry,
  });
  late final String? receptionistName;
  late final String? receptionistEmail;
  late final String? receptionistPhone;
  late final String? receptionistAddress;
  late final String? receptionistCountry;

  ReceptionistInfo.fromJson(Map<String, dynamic> json) {
    receptionistName = json['receptionist_name'] ?? "";
    receptionistEmail = json['receptionist_email'] ?? "";
    receptionistPhone = json['receptionist_phone'] ?? "";
    receptionistAddress = json['receptionist_address'] ?? "";
    receptionistCountry = json['receptionist_country'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['receptionist_name'] = receptionistName;
    _data['receptionist_email'] = receptionistEmail;
    _data['receptionist_phone'] = receptionistPhone;
    _data['receptionist_address'] = receptionistAddress;
    _data['receptionist_country'] = receptionistCountry;
    return _data;
  }
}

class ItemType {
  ItemType({
    required this.id,
    required this.uid,
    required this.category,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.description,
    required this.bookingId,
  });
  late final int id;
  late final int uid;
  late final String category;
  late final String itemName;
  late final String itemImage;
  late final int quantity;
  late final String description;
  late final int bookingId;

  ItemType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    category = json['category'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    quantity = json['quantity'] == null ? 0 : json['quantity'];
    description = json['description'];
    bookingId = json['booking_id'];
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
    return _data;
  }
}
