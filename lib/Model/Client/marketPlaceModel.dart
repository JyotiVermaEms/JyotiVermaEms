class MarketPlaceModel {
  MarketPlaceModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  MarketPlaceModel.fromJson(Map<String, dynamic> json) {
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
    required this.title,
    required this.category,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.deliveryDays,
    required this.items,
    required this.bookingPrice,
    required this.dropoff,
    required this.itemImage,
    required this.description,
    required this.needs,
    required this.status,
    this.uid,
    required this.bookingDate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String title;
  late final String category;
  late final String pickupLocation;
  late final String dropoffLocation;
  late final String deliveryDays;
  late final String items;
  late final String bookingPrice;
  late final String dropoff;
  late final String itemImage;
  late final String description;
  late final String needs;
  late final String status;
  late final Null uid;
  late final String bookingDate;
  late final String updatedAt;
  late final String createdAt;
  late final int id;

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    category = json['category'];
    pickupLocation = json['pickup_location'];
    dropoffLocation = json['dropoff_location'];
    deliveryDays = json['delivery_days'];
    items = json['items'] == null ? "" : json['items'];
    bookingPrice = json['booking_price'];
    dropoff = json['dropoff'];
    itemImage = json['item_image'];
    description = json['description'];
    needs = json['needs'];
    status = json['status'];
    uid = null;
    bookingDate = json['booking_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['category'] = category;
    _data['pickup_location'] = pickupLocation;
    _data['dropoff_location'] = dropoffLocation;
    _data['delivery_days'] = deliveryDays;
    _data['items'] = items;
    _data['booking_price'] = bookingPrice;
    _data['dropoff'] = dropoff;
    _data['item_image'] = itemImage;
    _data['description'] = description;
    _data['needs'] = needs;
    _data['status'] = status;
    _data['uid'] = uid;
    _data['booking_date'] = bookingDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}
