class ViewMarketPlaceBooking {
  ViewMarketPlaceBooking({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ViewMarketPlaceBooking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
  late final List<Proposal> proposal;

  Data.fromJson(Map<String, dynamic> json) {
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
    bookingPrice = json['booking_price'] == null ? 0 : json['booking_price'];
    description = json['description'];
    needs = json['needs'];
    proposal =
        List.from(json['proposal']).map((e) => Proposal.fromJson(e)).toList();
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

class Proposal {
  Proposal({
    required this.id,
    required this.uid,
    required this.sid,
    required this.mid,
    required this.proposals,
    this.type,
    this.pickupfee,
    this.shippingPrice,
    this.tax,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
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

  Proposal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    sid = json['sid'];
    mid = json['mid'];
    proposals = json['proposals'];
    type = null;
    pickupfee = null;
    shippingPrice = null;
    tax = null;
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
