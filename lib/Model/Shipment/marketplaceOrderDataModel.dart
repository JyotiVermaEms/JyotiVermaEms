class MarketplaceOrderDataModel {
  MarketplaceOrderDataModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<orderData> data;

  MarketplaceOrderDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => orderData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class orderData {
  orderData({
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
  late final List<dynamic> itemImage;
  late final List<Category> category;
  late final Null items;
  late final int bookingPrice;
  late final String description;
  late final String needs;
  late final List<Client> client;

  orderData.fromJson(Map<String, dynamic> json) {
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
    itemImage = List.castFrom<dynamic, dynamic>(json['item_image']);
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    items = null;
    bookingPrice = json['booking_price'];
    description = json['description'];
    needs = json['needs'];
    client = List.from(json['client']).map((e) => Client.fromJson(e)).toList();
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
    _data['client'] = client.map((e) => e.toJson()).toList();
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
    this.address,
    this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    this.aboutMe,
    this.language,
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
  late final Null address;
  late final Null profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final Null status;
  late final Null aboutMe;
  late final Null language;
  late final int clientId;
  late final String type;
  late final Null provider;
  late final String otp;

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'] == null ? "" : json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = json['username'];
    countryCode = null;
    country = json['country'] == null ? "" : json['country'];
    address = null;
    profileimage = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = null;
    aboutMe = null;
    language = null;
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
