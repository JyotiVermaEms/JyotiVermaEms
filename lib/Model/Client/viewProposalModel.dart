class ViewProposalModel {
  ViewProposalModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<ViewProposalData> data;

  ViewProposalModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => ViewProposalData.fromJson(e))
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

class ViewProposalData {
  ViewProposalData({
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
    required this.shipment,
    required this.market,
  });
  late final int id;
  late final int uid;
  late final int sid;
  late final int mid;
  late final String proposals;
  late final String? type;
  late final String? pickupfee;
  late final String? shippingPrice;
  late final String? tax;
  late final String status;
  late final String createdAt;
  late final String updatedAt;
  late final List<Shipment> shipment;
  late final List<Market> market;

  ViewProposalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    sid = json['sid'];
    mid = json['mid'];
    proposals = json['proposals'] == null ? "" : json['proposals'];
    type = json['type'] == null ? "" : json['type'];
    pickupfee = json['pickupfee'] == null ? "" : json['pickupfee'];
    shippingPrice =
        json['shipping_price'] == null ? "" : json['shipping_price'];
    tax = json['tax'] == null ? "" : json['tax'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shipment =
        List.from(json['shipment']).map((e) => Shipment.fromJson(e)).toList();
    market = List.from(json['market']).map((e) => Market.fromJson(e)).toList();
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
    _data['shipment'] = shipment.map((e) => e.toJson()).toList();
    _data['market'] = market.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Shipment {
  Shipment({
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.phone,
    required this.username,
    this.countryCode,
    this.companyname,
    required this.annualshipment,
    required this.country,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.profileimage,
    this.docs,
    required this.status,
    this.drivingLicence,
    this.taxDocs,
    required this.aboutMe,
    required this.language,
    required this.type,
    this.shipmentId,
    this.provider,
    this.otp,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String phone;
  late final String username;
  late final Null countryCode;
  late final String? companyname;
  late final String annualshipment;
  late final String country;
  late final String address;
  late final String createdAt;
  late final String updatedAt;
  late final String roles;
  late final Null profileimage;
  late final Null docs;
  late final String status;
  late final Null drivingLicence;
  late final Null taxDocs;
  late final String aboutMe;
  late final String language;
  late final String type;
  late final Null shipmentId;
  late final Null provider;
  late final String? otp;

  Shipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    phone = json['phone'];
    username = json['username'] == null ? "" : json['username'];
    countryCode = null;
    companyname = json['companyname'] == null ? "" : json['companyname'];
    annualshipment =
        json['annualshipment'] == null ? "NA" : json['annualshipment'];
    country = json['country'];
    address = json['address'] == null ? "" : json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roles = json['roles'];
    profileimage = null;
    docs = null;
    status = json['status'];
    drivingLicence = null;
    taxDocs = null;
    aboutMe = json['about_me'];
    language = json['language'];
    type = json['type'];
    shipmentId = null;
    provider = null;
    otp = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['username'] = username;
    _data['country_code'] = countryCode;
    _data['companyname'] = companyname;
    _data['annualshipment'] = annualshipment;
    _data['country'] = country;
    _data['address'] = address;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['roles'] = roles;
    _data['profileimage'] = profileimage;
    _data['docs'] = docs;
    _data['status'] = status;
    _data['driving_licence'] = drivingLicence;
    _data['tax_docs'] = taxDocs;
    _data['about_me'] = aboutMe;
    _data['language'] = language;
    _data['type'] = type;
    _data['shipment_id'] = shipmentId;
    _data['provider'] = provider;
    _data['otp'] = otp;
    return _data;
  }
}

class Market {
  Market({
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

  Market.fromJson(Map<String, dynamic> json) {
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
    bookingPrice = json['booking_price'] == null ? 0 : json['booking_price'];
    description = json['description'];
    needs = json['needs'];
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
    return _data;
  }
}
