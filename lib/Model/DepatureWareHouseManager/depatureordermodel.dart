class DepatureOrderModel {
  DepatureOrderModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<DepatureOrder> data;

  DepatureOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        List.from(json['data']).map((e) => DepatureOrder.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DepatureOrder {
  DepatureOrder({
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
    required this.accepted,
    required this.rejected,
    required this.pickupReview,
    required this.scheduleId,
    required this.pickupagentId,
    required this.pickupAccept,
    required this.pickupItemimage,
    required this.pickupItemimage1,
    required this.pickupComment,
    required this.pickupComment1,
    required this.departureImage,
    required this.departureComment,
    required this.arrivalImage,
    required this.arrivalComment,
    required this.receptionistImage,
    required this.receptionistInfo,
    required this.receptionistId,
    required this.transactionId,
    required this.totalAmount,
    required this.cardType,
    required this.reason,
    required this.pickupReason,
    required this.createdAt,
    required this.updatedAt,
    required this.expiredAt,
    required this.receptionistComment,
    required this.schedule,
    required this.client,
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
  late final List<BookingItem> bookingItem;
  late final String status;
  late final int accepted;
  late final int rejected;
  late final List<PickupReview> pickupReview;
  late final String scheduleId;
  late final int? pickupagentId;
  late final int pickupAccept;
  late final String? pickupItemimage;
  late final String? pickupItemimage1;
  late final String? pickupComment;
  late final String? pickupComment1;
  late final String? departureImage;
  late final String departureComment;
  late final String? arrivalImage;
  late final String arrivalComment;
  late final String receptionistImage;
  late final List<ReceptionistInfo> receptionistInfo;
  late final int receptionistId;
  late final String transactionId;
  late final String totalAmount;
  late final String cardType;
  late final String reason;
  late final String pickupReason;
  late final String createdAt;
  late final String updatedAt;
  late final String expiredAt;
  late final String receptionistComment;
  late final List<Schedule> schedule;
  late final Client client;

  DepatureOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    uid = json['uid'];
    bookingDate = json['booking_date'];
    arrivalDate = json['arrival_date'];
    bookingType = json['booking_type'];
    from = json['from'];
    to = json['to'];
    shipmentCompany = json['shipment_company'];
    bookingItem = List.from(json['booking_item'])
        .map((e) => BookingItem.fromJson(e))
        .toList();
    status = json['status'];
    accepted = json['accepted'];
    rejected = json['rejected'];
    pickupReview = List.from(json['pickup_review'])
        .map((e) => PickupReview.fromJson(e))
        .toList();
    scheduleId = json['schedule_id'];
    pickupagentId =
        json['pickupagent_id'] == null ? 0 : json['pickupagent_id'];
    pickupAccept = json['pickup_accept'] == null ? "" : json['pickup_accept'];
    pickupItemimage =
        json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
    pickupItemimage1 =
        json['pickup_itemimage1'] == null ? "" : json['pickup_itemimage1'];
    pickupComment =
        json['pickup_comment'] == null ? "" : json['pickup_comment'];
    pickupComment1 =
        json['pickup_comment1'] == null ? "" : json['pickup_comment1'];
    departureImage =
        json['departure_image'] == null ? "" : json['departure_image'];
    departureComment =
        json['departure_comment'] == null ? "" : json['departure_comment'];
    arrivalImage = json['arrival_image'] == null ? "" : json['arrival_image'];
    arrivalComment =
        json['arrival_comment'] == null ? "" : json['arrival_comment'];
    receptionistImage =
        json['receptionist_image'] == null ? "" : json['receptionist_image'];
    receptionistInfo = List.from(json['receptionist_info'])
        .map((e) => ReceptionistInfo.fromJson(e))
        .toList();
    receptionistId = json['receptionist_id'];
    transactionId = json['transaction_id'];
    totalAmount = json['total_amount'];
    cardType = json['card_type'];
    reason = json['reason'] == null ? "" : json['reason'];
    pickupReason = json['pickup_reason'] == null ? "" : json['pickup_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expiredAt = json['expired_at'] == null ? "" : json['expired_at'];
    receptionistComment = json['receptionist_comment'] == null
        ? ""
        : json['receptionist_comment'];
    schedule =
        List.from(json['schedule']).map((e) => Schedule.fromJson(e)).toList();
    client = Client.fromJson(json['client']);
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
    _data['booking_item'] = bookingItem.map((e) => e.toJson()).toList();
    _data['status'] = status;
    _data['accepted'] = accepted;
    _data['rejected'] = rejected;
    _data['pickup_review'] = pickupReview.map((e) => e.toJson()).toList();
    _data['schedule_id'] = scheduleId;
    _data['pickupagent_id'] = pickupagentId;
    _data['pickup_accept'] = pickupAccept;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['pickup_itemimage1'] = pickupItemimage1;
    _data['pickup_comment'] = pickupComment;
    _data['pickup_comment1'] = pickupComment1;
    _data['departure_image'] = departureImage;
    _data['departure_comment'] = departureComment;
    _data['arrival_image'] = arrivalImage;
    _data['arrival_comment'] = arrivalComment;
    _data['receptionist_image'] = receptionistImage;
    _data['receptionist_info'] =
        receptionistInfo.map((e) => e.toJson()).toList();
    _data['receptionist_id'] = receptionistId;
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['reason'] = reason;
    _data['pickup_reason'] = pickupReason;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['expired_at'] = expiredAt;
    _data['receptionist_comment'] = receptionistComment;
    _data['schedule'] = schedule.map((e) => e.toJson()).toList();
    _data['client'] = client.toJson();
    return _data;
  }
}

class BookingItem {
  BookingItem({
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
  late final List<String> itemImage;
  late final int quantity;
  late final String description;
  late final int bookingId;
  late final int scheduleId;

  BookingItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    category = json['category'];
    itemName = json['item_name'];
    itemImage = List.castFrom<dynamic, String>(json['item_image']);
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
  late final String receptionistName;
  late final String receptionistEmail;
  late final String receptionistPhone;
  late final String receptionistAddress;
  late final String receptionistCountry;

  ReceptionistInfo.fromJson(Map<String, dynamic> json) {
    receptionistName = json['receptionist_name'];
    receptionistEmail = json['receptionist_email'];
    receptionistPhone = json['receptionist_phone'];
    receptionistAddress = json['receptionist_address']==null?"":json['receptionist_address'];
    receptionistCountry = json['receptionist_country'];
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

class Schedule {
  Schedule({
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

  Schedule.fromJson(Map<String, dynamic> json) {
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
    return _data;
  }
}

class Client {
  Client({
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    required this.username,
    this.countryCode,
    required this.country,
    required this.address,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    required this.aboutMe,
    required this.language,
    required this.clientId,
    required this.type,
    this.provider,
    required this.otp,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String roles;
  late final String phone;
  late final String username;
  late final Null countryCode;
  late final String country;
  late final String address;
  late final String profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final Null status;
  late final String aboutMe;
  late final String language;
  late final int clientId;
  late final String type;
  late final Null provider;
  late final String otp;

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = json['username'];
    countryCode = null;
    country = json['country'] == null ? "" : json['country'];
    address = json['address'] == null ? "" : json['address'];
    profileimage = json['profileimage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = null;
    aboutMe = json['about_me'] == null ? "" : json['about_me'];
    language = json['language'];
    clientId = json['client_id'];
    type = json['type'];
    provider = null;
    otp = json['otp'];
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
    _data['about_me'] = aboutMe;
    _data['language'] = language;
    _data['client_id'] = clientId;
    _data['type'] = type;
    _data['provider'] = provider;
    _data['otp'] = otp;
    return _data;
  }
}

// ===================================
class DepartureMarketOrderModel {
  DepartureMarketOrderModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<DepatureMArketData> data;

  DepartureMarketOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => DepatureMArketData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DepatureMArketData {
  DepatureMArketData({
    required this.id,
    required this.title,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.deliveryDays,
    required this.dropoff,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
    required this.bookingDate,
    required this.sid,
    required this.itemImage,
    required this.category,
    this.items,
    required this.bookingPrice,
    required this.description,
    required this.needs,
    required this.marketStatus,
    required this.mid,
    required this.receptionistId,
    required this.pickupagentId,
    required this.departureId,
    required this.arrivalId,
    required this.pickupItemimage,
    required this.pickupItemimage1,
    required this.pickupComment,
    required this.pickupComment1,
    required this.departureImage,
    required this.departureComment,
    required this.arrivalImage,
    required this.arrivalComment,
    required this.receptionistImage,
    required this.receptionistComment,
    required this.transactionId,
    required this.totalAmount,
    required this.cardType,
    required this.client,
  });
  late final int id;
  late final String title;
  late final String pickupLocation;
  late final String dropoffLocation;
  late final String deliveryDays;
  late final String dropoff;
  late final String status;
  late final String createdAt;
  late final String updatedAt;
  late final int uid;
  late final String bookingDate;
  late final int sid;
  late final String itemImage;
  late final String category;
  late final Null items;
  late final int bookingPrice;
  late final String description;
  late final String needs;
  late final String marketStatus;
  late final int mid;
  late final int receptionistId;
  late final int pickupagentId;
  late final int departureId;
  late final int arrivalId;
  late final String? pickupItemimage;
  late final String pickupItemimage1;
  late final String pickupComment;
  late final String pickupComment1;
  late final String departureImage;
  late final String departureComment;
  late final String arrivalImage;
  late final String arrivalComment;
  late final String receptionistImage;
  late final String receptionistComment;
  late final String transactionId;
  late final int totalAmount;
  late final String cardType;
  late final List<ClientData> client;

  DepatureMArketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    pickupLocation = json['pickup_location'];
    dropoffLocation = json['dropoff_location'];
    deliveryDays = json['delivery_days'];
    dropoff = json['dropoff'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uid = json['uid'];
    bookingDate = json['booking_date'];
    sid = json['sid'];
    itemImage = json['item_image'];
    category = json['category'];
    items = null;
    bookingPrice = json['booking_price'];
    description = json['description'];
    needs = json['needs'];
    marketStatus = json['market_status'];
    mid = json['mid'];
    receptionistId = json['receptionist_id'];
    pickupagentId = json['pickupagent_id'];
    departureId = json['departure_id'];
    arrivalId = json['arrival_id'];
    pickupItemimage =
        json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
    pickupItemimage1 =
        json['pickup_itemimage1'] == null ? "" : json['pickup_itemimage1'];

    pickupComment =
        json['pickup_comment'] == null ? "" : json['pickup_comment'];
    pickupComment1 =
        json['pickup_comment1'] == null ? "" : json['pickup_comment1'];
    departureImage =
        json['departure_image'] == null ? "" : json['departure_image'];
    departureComment =
        json['departure_comment'] == null ? "" : json['departure_comment'];
    arrivalImage = json['arrival_image'] == null ? "" : json['arrival_image'];
    arrivalComment =
        json['arrival_comment'] == null ? "" : json['arrival_comment'];
    receptionistImage =
        json['receptionist_image'] == null ? "" : json['receptionist_image'];
    receptionistComment = json['receptionist_comment'] == null
        ? ""
        : json['receptionist_comment'];
    transactionId =
        json['transaction_id'] == null ? "" : json['transaction_id'];
    totalAmount = json['total_amount'] == null ? 0 : json['total_amount'];
    cardType = json['card_type'] == null ? "" : json['card_type'];
    client =
        List.from(json['client']).map((e) => ClientData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['pickup_location'] = pickupLocation;
    _data['dropoff_location'] = dropoffLocation;
    _data['delivery_days'] = deliveryDays;
    _data['dropoff'] = dropoff;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['uid'] = uid;
    _data['booking_date'] = bookingDate;
    _data['sid'] = sid;
    _data['item_image'] = itemImage;
    _data['category'] = category;
    _data['items'] = items;
    _data['booking_price'] = bookingPrice;
    _data['description'] = description;
    _data['needs'] = needs;
    _data['market_status'] = marketStatus;
    _data['mid'] = mid;
    _data['receptionist_id'] = receptionistId;
    _data['pickupagent_id'] = pickupagentId;
    _data['departure_id'] = departureId;
    _data['arrival_id'] = arrivalId;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['pickup_itemimage1'] = pickupItemimage1;
    _data['pickup_comment'] = pickupComment;
    _data['pickup_comment1'] = pickupComment1;
    _data['departure_image'] = departureImage;
    _data['departure_comment'] = departureComment;
    _data['arrival_image'] = arrivalImage;
    _data['arrival_comment'] = arrivalComment;
    _data['receptionist_image'] = receptionistImage;
    _data['receptionist_comment'] = receptionistComment;
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['client'] = client.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ClientData {
  ClientData({
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    required this.username,
    this.countryCode,
    required this.country,
    required this.address,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    required this.aboutMe,
    required this.language,
    required this.clientId,
    required this.type,
    this.provider,
    required this.otp,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String roles;
  late final String phone;
  late final String username;
  late final Null countryCode;
  late final String country;
  late final String address;
  late final String profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final Null status;
  late final String aboutMe;
  late final String language;
  late final int clientId;
  late final String type;
  late final Null provider;
  late final String otp;

  ClientData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = json['username'];
    countryCode = null;
    country = json['country'] == null ? "" : json['country'];
    address = json['address'] == null ? "" : json['address'];
    profileimage = json['profileimage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = null;
    aboutMe = json['about_me'] == null ? "" : json['about_me'];
    language = json['language'];
    clientId = json['client_id'];
    type = json['type'];
    provider = null;
    otp = json['otp'];
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
    _data['about_me'] = aboutMe;
    _data['language'] = language;
    _data['client_id'] = clientId;
    _data['type'] = type;
    _data['provider'] = provider;
    _data['otp'] = otp;
    return _data;
  }
}
