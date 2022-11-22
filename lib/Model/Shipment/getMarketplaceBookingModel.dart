class GetMarketplaceBookingModel {
  GetMarketplaceBookingModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<MarketPlace> data;

  GetMarketplaceBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => MarketPlace.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class MarketPlace {
  MarketPlace({
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
    required this.items,
    required this.bookingPrice,
    required this.description,
    required this.needs,
    required this.proposal,
    required this.proposalStatus,
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
  late final itemImage;
  late final List<Category> category;
  late final String items;
  late final int bookingPrice;
  late final String description;
  late final String needs;
  late final List<Proposal> proposal;
  late final String proposalStatus;
  late final List<Client> client;

  MarketPlace.fromJson(Map<String, dynamic> json) {
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
    sid = json['sid'] ?? 0;
    itemImage = json['item_image'];
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();

    items = json['items'] ?? "";
    bookingPrice = json['booking_price'];
    description = json['description'];
    needs = json['needs'];
    proposal =
        List.from(json['proposal']).map((e) => Proposal.fromJson(e)).toList();
    proposalStatus = json['proposal_status'];
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
    _data['proposal'] = proposal.map((e) => e.toJson()).toList();
    _data['proposal_status'] = proposalStatus;
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
    categoryItem = json['categoryItem'] ?? "";
    bookingAttribute =
        List.castFrom<dynamic, String>(json['booking_attribute']);

    quantity = json['quantity'] ?? "";
    icon = json['icon'] ?? "";
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

class Proposal {
  Proposal({
    required this.id,
    required this.uid,
    required this.sid,
    required this.mid,
    required this.proposals,
    required this.type,
    required this.pickupfee,
    required this.shippingPrice,
    required this.tax,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int uid;
  late final int sid;
  late final int mid;
  late final String proposals;
  late final String type;
  late final String pickupfee;
  late final String shippingPrice;
  late final String tax;
  late final String status;
  late final String createdAt;
  late final String updatedAt;

  Proposal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    sid = json['sid'];
    mid = json['mid'];
    proposals = json['proposals'];
    type = json['type'];
    pickupfee = json['pickupfee'];
    shippingPrice = json['shipping_price'];
    tax = json['tax'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['sid'] = sid;
    _data['mid'] = mid;
    _data['proposals'] = proposals;
    _data['type'] = type;
    _data['pickupfee'] = pickupfee;
    _data['shipping_price'] = shippingPrice;
    _data['tax'] = tax;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
//=======new model create

class Autogenerated {
  late bool status;
  late String message;
  late List<Data> data;

  Autogenerated(
      {required this.status, required this.message, required this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  late int id;
  late int uid;
  late int mid;
  late int sid;
  late int receptionistId;
  late int pickupagentId;
  late int departureId;
  late int arrivalId;
  late String status;
  late String createdAt;
  late String updatedAt;
  late String title;
  late String pickupLocation;
  late String dropoffLocation;
  late String deliveryDays;
  late String dropoff;
  late String bookingDate;
  late String itemImage;
  late String category;
  Null items;
  late int bookingPrice;
  late String description;
  late String needs;

  Data(
      {required this.id,
      required this.uid,
      required this.mid,
      required this.sid,
      required this.receptionistId,
      required this.pickupagentId,
      required this.departureId,
      required this.arrivalId,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.pickupLocation,
      required this.dropoffLocation,
      required this.deliveryDays,
      required this.dropoff,
      required this.bookingDate,
      required this.itemImage,
      required this.category,
      required this.items,
      required this.bookingPrice,
      required this.description,
      required this.needs});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    mid = json['mid'];
    sid = json['sid'];
    receptionistId = json['receptionist_id'];
    pickupagentId = json['pickupagent_id'];
    departureId = json['departure_id'];
    arrivalId = json['arrival_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    pickupLocation = json['pickup_location'];
    dropoffLocation = json['dropoff_location'];
    deliveryDays = json['delivery_days'];
    dropoff = json['dropoff'];
    bookingDate = json['booking_date'];
    itemImage = json['item_image'];
    category = json['category'];
    items = json['items'];
    bookingPrice = json['booking_price'];
    description = json['description'];
    needs = json['needs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['mid'] = this.mid;
    data['sid'] = this.sid;
    data['receptionist_id'] = this.receptionistId;
    data['pickupagent_id'] = this.pickupagentId;
    data['departure_id'] = this.departureId;
    data['arrival_id'] = this.arrivalId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['pickup_location'] = this.pickupLocation;
    data['dropoff_location'] = this.dropoffLocation;
    data['delivery_days'] = this.deliveryDays;
    data['dropoff'] = this.dropoff;
    data['booking_date'] = this.bookingDate;
    data['item_image'] = this.itemImage;
    data['category'] = this.category;
    data['items'] = this.items;
    data['booking_price'] = this.bookingPrice;
    data['description'] = this.description;
    data['needs'] = this.needs;
    return data;
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
    required this.profileimage,
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
  late final String? status;
  late final String? aboutMe;
  late final String? language;
  late final int clientId;
  late final String type;
  late final String provider;
  late final String otp;

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'] == null ? "" : json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = json['username'];
    countryCode = json['countryCode'] == null ? "" : json['countryCode'];
    country = json['country'] == null ? "" : json['country'];
    address = json['address'] == null ? "" : json['address'];
    profileimage = json['profileimage'] == null ? "" : json['profileimage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] == null ? "" : json['status'];
    aboutMe = json['aboutMe'] == null ? "" : json['aboutMe'];
    language = json['language'] == null ? "" : json['language'];
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
