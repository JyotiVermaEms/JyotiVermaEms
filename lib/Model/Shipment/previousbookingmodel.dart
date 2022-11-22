class PreviousBookingShipmentModel {
  PreviousBookingShipmentModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<PreBookingData> data;

  PreviousBookingShipmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => PreBookingData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PreBookingData {
  PreBookingData({
    required this.id,
    required this.title,
    required this.shipmentType,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.arrivalDate,
    required this.departureWarehouse,
    required this.destinationWarehouse,
    required this.itemType,
    required this.createdAt,
    required this.updatedAt,
    required this.sid,
    required this.status,
    required this.permissionStatus,
    required this.bookingId,
    required this.booking,
  });
  late final int id;
  late final String title;
  late final String shipmentType;
  late final String from;
  late final String to;
  late final String departureDate;
  late final String arrivalDate;
  late final String departureWarehouse;
  late final String destinationWarehouse;
  late final String itemType;
  late final String createdAt;
  late final String updatedAt;
  late final int sid;
  late final String status;
  late final String permissionStatus;
  late final int bookingId;
  late final List<Booking> booking;

  PreBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shipmentType = json['shipment_type'];
    from = json['from'];
    to = json['to'];
    departureDate = json['departure_date'];
    arrivalDate = json['arrival_date'];
    departureWarehouse = json['departure_warehouse'];
    destinationWarehouse = json['destination_warehouse'];
    itemType = json['item_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sid = json['sid'];
    status = json['status'];
    permissionStatus = json['permission_status'];
    bookingId = json['booking_id'];
    booking =
        List.from(json['booking']).map((e) => Booking.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['shipment_type'] = shipmentType;
    _data['from'] = from;
    _data['to'] = to;
    _data['departure_date'] = departureDate;
    _data['arrival_date'] = arrivalDate;
    _data['departure_warehouse'] = departureWarehouse;
    _data['destination_warehouse'] = destinationWarehouse;
    _data['item_type'] = itemType;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['sid'] = sid;
    _data['status'] = status;
    _data['permission_status'] = permissionStatus;
    _data['booking_id'] = bookingId;
    _data['booking'] = booking.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Booking {
  Booking({
    required this.id,
    required this.title,
    required this.uid,
    required this.bookingDate,
    required this.arrivalDate,
    required this.bookingType,
    required this.from,
    required this.to,
    required this.shipmentCompany,
    this.bookingItem,
    required this.status,
    required this.accepted,
    required this.rejected,
    required this.pickupReview,
    required this.scheduleId,
    this.pickupagentId,
    this.pickupItemimage,
    required this.receptionistInfo,
    required this.transactionId,
    required this.totalAmount,
    required this.cardType,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String title;
  late final int uid;
  late final String bookingDate;
  late final String arrivalDate;
  late final String bookingType;
  late final String from;
  late final String to;
  late final String shipmentCompany;
  late final Null bookingItem;
  late final String status;
  late final int accepted;
  late final int rejected;
  late final List<PickupReview> pickupReview;
  late final String scheduleId;
  late final Null pickupagentId;
  late final Null pickupItemimage;
  late final List<ReceptionistInfo> receptionistInfo;
  late final String transactionId;
  late final String totalAmount;
  late final String cardType;
  late final String createdAt;
  late final String updatedAt;

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    uid = json['uid'];
    bookingDate = json['booking_date'];
    arrivalDate = json['arrival_date'];
    bookingType = json['booking_type'];
    from = json['from'];
    to = json['to'];
    shipmentCompany = json['shipment_company'];
    bookingItem = null;
    status = json['status'];
    accepted = json['accepted'];
    rejected = json['rejected'];
    pickupReview = List.from(json['pickup_review'])
        .map((e) => PickupReview.fromJson(e))
        .toList();
    scheduleId = json['schedule_id'];
    pickupagentId = null;
    pickupItemimage = null;
    receptionistInfo = List.from(json['receptionist_info'])
        .map((e) => ReceptionistInfo.fromJson(e))
        .toList();
    transactionId = json['transaction_id'];
    totalAmount = json['total_amount'];
    cardType = json['card_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
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
    _data['pickupagent_id'] = pickupagentId;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['receptionist_info'] =
        receptionistInfo.map((e) => e.toJson()).toList();
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class PickupReview {
  PickupReview({
    required this.pickupType,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    this.pickupDistance,
    this.pickupEstimate,
  });
  late final String pickupType;
  late final String pickupLocation;
  late final String pickupDate;
  late final String pickupTime;
  late final String? pickupDistance;
  late final String? pickupEstimate;

  PickupReview.fromJson(Map<String, dynamic> json) {
    pickupType = json['pickup_type'];
    pickupLocation = json['pickup_location'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
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
    this.receptionistCountry,
  });
  late final String receptionistName;
  late final String receptionistEmail;
  late final String receptionistPhone;
  late final String receptionistAddress;
  late final String? receptionistCountry;

  ReceptionistInfo.fromJson(Map<String, dynamic> json) {
    receptionistName = json['receptionist_name'];
    receptionistEmail = json['receptionist_email'];
    receptionistPhone = json['receptionist_phone'];
    receptionistAddress = json['receptionist_address'];
    receptionistCountry = null;
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
