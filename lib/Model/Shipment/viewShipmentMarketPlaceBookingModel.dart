class ViewShipmentMarketPlaceBookingModel {
  ViewShipmentMarketPlaceBookingModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<MarketPlaceData> data;

  ViewShipmentMarketPlaceBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => MarketPlaceData.fromJson(e))
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

class MarketPlaceData {
  MarketPlaceData({
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
    required this.bookingAttribute,
    required this.items,
    required this.bookingPrice,
    required this.description,
    required this.needs,
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
  late final List<Category> category;
  late final String bookingAttribute;
  late final String items;
  late final int bookingPrice;
  late final String description;
  late final String needs;
  late final Client client;

  MarketPlaceData.fromJson(Map<String, dynamic> json) {
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
    itemImage = json['item_image'] == null ? "" : json['item_image'];
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    bookingAttribute =
        json['booking_attribute'] == null ? "" : json['booking_attribute'];
    items = json['items'];
    bookingPrice = json['booking_price'];
    description = json['description'];
    needs = json['needs'];
    client = Client.fromJson(json['client']);
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
    _data['booking_attribute'] = bookingAttribute;
    _data['items'] = items;
    _data['booking_price'] = bookingPrice;
    _data['description'] = description;
    _data['needs'] = needs;
    _data['client'] = client.toJson();
    return _data;
  }
}

class Category {
  Category({
    required this.category,
    required this.bookingAttribute,
    required this.icon,
  });
  late final String category;
  late final List<String> bookingAttribute;
  late final String icon;

  Category.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    bookingAttribute =
        List.castFrom<dynamic, String>(json['booking_attribute']);
    icon = json['icon'] == null ? "" : json['icon'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    _data['booking_attribute'] = bookingAttribute;
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
    required this.countryCode,
    required this.country,
    required this.address,
    this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.aboutMe,
    required this.language,
    required this.clientId,
    required this.type,
    required this.provider,
    required this.otp,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String roles;
  late final String phone;
  late final String username;
  late final String? countryCode;
  late final String country;
  late final String address;
  late final String? profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final String status;
  late final String aboutMe;
  late final String language;
  late final int clientId;
  late final String type;
  late final String provider;
  late final String otp;

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = json['username'];
    countryCode = json['country_code'] == null ? "" : json['country_code'];
    country = json['country'];
    address = json['address'] == null ? "" : json['address'];
    profileimage = json['profileimage'] == null ? "" : json['profileimage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    aboutMe = json['about_me'];
    language = json['language'];
    clientId = json['client_id'];
    type = json['type'];
    provider = json['provider'] == null ? "" : json['provider'];
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
