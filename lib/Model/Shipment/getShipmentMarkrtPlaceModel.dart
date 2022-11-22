class ShipmentMarketPlaceModel {
  ShipmentMarketPlaceModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<SMPResponse> data;

  ShipmentMarketPlaceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => SMPResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SMPResponse {
  SMPResponse({
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
    required this.client,
    required this.marketplaceBookingid,
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
  late final List<Category> category;
  late final Null items;
  late final int bookingPrice;
  late final String description;
  late final String needs;
  late final Client client;
  late final List<MarketplaceBookingid> marketplaceBookingid;

  SMPResponse.fromJson(Map<String, dynamic> json) {
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
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    items = null;
    bookingPrice = json['booking_price'];
    description = json['description'];
    needs = json['needs'];
    client = Client.fromJson(json['client']);
    marketplaceBookingid = List.from(json['marketplace_bookingid'])
        .map((e) => MarketplaceBookingid.fromJson(e))
        .toList();
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
    _data['category'] = category.map((e) => e.toJson()).toList();
    _data['items'] = items;
    _data['booking_price'] = bookingPrice;
    _data['description'] = description;
    _data['needs'] = needs;
    _data['client'] = client.toJson();
    _data['marketplace_bookingid'] =
        marketplaceBookingid.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Category {
  Category({
    required this.categoryItem,
    required this.bookingAttribute,
    required this.quantity,
    required this.icon,
  });
  late final String categoryItem;
  late final List<String> bookingAttribute;
  late final String quantity;
  late final String icon;

  Category.fromJson(Map<String, dynamic> json) {
    categoryItem = json['categoryItem'];
    bookingAttribute =
        List.castFrom<dynamic, String>(json['booking_attribute']);
    quantity = json['quantity'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categoryItem'] = categoryItem;
    _data['booking_attribute'] = bookingAttribute;
    _data['quantity'] = quantity;
    _data['icon'] = icon;
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
    address = json['address'];
    profileimage = json['profileimage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = null;
    aboutMe = json['about_me'];
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

class MarketplaceBookingid {
  MarketplaceBookingid({
    required this.id,
    required this.uid,
    required this.mid,
    required this.sid,
    required this.receptionistId,
    required this.pickupagentId,
    required this.departureId,
    required this.arrivalId,
    required this.status,
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
    required this.receptionistComment,
    required this.transactionId,
    required this.totalAmount,
    required this.cardType,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int uid;
  late final int mid;
  late final int sid;
  late final int receptionistId;
  late final int pickupagentId;
  late final int departureId;
  late final int arrivalId;
  late final String status;
  late final int pickupAccept;
  late final String pickupItemimage;
  late final String? pickupItemimage1;
  late final String? pickupComment;
  late final String? pickupComment1;
  late final String? departureImage;
  late final String? departureComment;
  late final String? arrivalImage;
  late final String? arrivalComment;
  late final String? receptionistImage;
  late final String? receptionistComment;
  late final String transactionId;
  late final int totalAmount;
  late final String cardType;
  late final String createdAt;
  late final String updatedAt;

  MarketplaceBookingid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    mid = json['mid'];
    sid = json['sid'];
    receptionistId = json['receptionist_id'];
    pickupagentId = json['pickupagent_id'];
    departureId = json['departure_id'];
    arrivalId = json['arrival_id'];
    status = json['status'];
    pickupAccept = json['pickup_accept'];
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
    totalAmount = json['total_amount'];
    cardType = json['card_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['mid'] = mid;
    _data['sid'] = sid;
    _data['receptionist_id'] = receptionistId;
    _data['pickupagent_id'] = pickupagentId;
    _data['departure_id'] = departureId;
    _data['arrival_id'] = arrivalId;
    _data['status'] = status;
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
    _data['receptionist_comment'] = receptionistComment;
    _data['transaction_id'] = transactionId;
    _data['total_amount'] = totalAmount;
    _data['card_type'] = cardType;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
