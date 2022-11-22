class ConfirmOrdersModel {
  ConfirmOrdersModel({
    required this.status,
    required this.message,
    required this.schedule,
  });
  late final bool status;
  late final String message;
  late final List<Schedule> schedule;

  ConfirmOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    schedule =
        List.from(json['schedule']).map((e) => Schedule.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['schedule'] = schedule.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Schedule {
  Schedule({
    required this.id,
    required this.title,
    required this.uid,
    required this.bookingDate,
    required this.arrivalDate,
    required this.bookingType,
    required this.from,
    required this.to,
    required this.shipmentCompany,
    required this.bookingItem,
    required this.status,
    required this.pickupReview,
    required this.scheduleId,
    required this.receptionistInfo,
    required this.transactionId,
    required this.totalAmount,
    required this.cardType,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.lname,
    required this.email,
    required this.password,
    required this.roles,
    required this.phone,
    required this.country,
    required this.address,
    required this.profileimage,
    required this.aboutMe,
    required this.language,
    required this.clientId,
    required this.type,
    required this.bookingStatus,
    required this.bookingId,
    required this.schedulesId,
    required this.schedulesStatus,
    required this.bookingItems,
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
  late final String bookingItem;
  late final String status;
  late final List<PickupReview> pickupReview;
  late final String scheduleId;
  late final String receptionistInfo;
  late final String transactionId;
  late final String totalAmount;
  late final String cardType;
  late final String createdAt;
  late final String updatedAt;
  late final String name;
  late final String lname;
  late final String email;
  late final String password;
  late final String roles;
  late final String phone;
  late final String country;
  late final String address;
  late final String profileimage;
  late final String aboutMe;
  late final String language;
  late final int clientId;
  late final String type;
  late final String bookingStatus;
  late final int bookingId;
  late final int schedulesId;
  late final String schedulesStatus;
  late final List<BookingItems> bookingItems;

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    uid = json['uid'];
    bookingDate = json['booking_date'];
    arrivalDate = json['arrival_date'];
    bookingType = json['booking_type'];
    from = json['from'];
    to = json['to'];
    shipmentCompany = json['shipment_company'];
    bookingItem = json['booking_item'];
    status = json['status'];
    pickupReview = List.from(json['pickup_review'])
        .map((e) => PickupReview.fromJson(e))
        .toList();
    scheduleId = json['schedule_id'];
    receptionistInfo = json['receptionist_info'];
    transactionId = json['transaction_id'];
    totalAmount = json['total_amount'];
    cardType = json['card_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    password = json['password'];
    roles = json['roles'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'] == null ? "" : json['address'];
    profileimage = json['profileimage'] == null ? "" : json['profileimage'];
    aboutMe = json['about_me'] == null ? "" : json['about_me'];
    language = json['language'] == null ? "" : json['language'];
    clientId = json['client_id'];
    type = json['type'];
    bookingStatus = json['booking_status'];
    bookingId = json['booking_id'];
    schedulesId = json['schedules_id'];
    schedulesStatus = json['schedules_status'];
    bookingItems = List.from(json['booking_items'])
        .map((e) => BookingItems.fromJson(e))
        .toList();
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
    _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
    _data['schedule_id'] = scheduleId;
    _data['receptionist_info'] = receptionistInfo;
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['password'] = password;
    _data['roles'] = roles;
    _data['phone'] = phone;
    _data['country'] = country;
    _data['address'] = address;
    _data['profileimage'] = profileimage;
    _data['about_me'] = aboutMe;
    _data['language'] = language;
    _data['client_id'] = clientId;
    _data['type'] = type;
    _data['booking_status'] = bookingStatus;
    _data['booking_id'] = bookingId;
    _data['schedules_id'] = schedulesId;
    _data['schedules_status'] = schedulesStatus;
    _data['booking_items'] = bookingItems.map((e) => e.toJson()).toList();
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
    pickupDate = json['pickupDate'] == null ? "" : json['pickupDate'];
    pickupTime = json['pickupTime'] == null ? "" : json['pickupTime'];
    pickupDistance =
        json['pickupDistance'] == null ? "" : json['pickupDistance'];
    pickupEstimate =
        json['pickupEstimate'] == null ? "" : json['pickupEstimate'];
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

class BookingItems {
  BookingItems({
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
  late final String quantity;
  late final String description;
  late final int bookingId;

  BookingItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    category = json['category'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    quantity = json['quantity'];
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
