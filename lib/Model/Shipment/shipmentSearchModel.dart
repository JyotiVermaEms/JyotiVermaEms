class ShipmentSearchModel {
  ShipmentSearchModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<SearchData> data;

  ShipmentSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => SearchData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SearchData {
  SearchData({
    required this.id,
    required this.title,
    required this.shipmentType,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.arrivalDate,
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
  late final String? title;
  late final String shipmentType;
  late final String from;
  late final String to;
  late final String departureDate;
  late final String arrivalDate;
  late final String destinationWarehouse;
  late final List<ItemType> itemType;
  late final String createdAt;
  late final String updatedAt;
  late final int sid;
  late final String status;
  late final String permissionStatus;
  late final int bookingId;

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] == null ? "" : json['title'];
    shipmentType = json['shipment_type'];
    from = json['from'];
    to = json['to'];
    departureDate = json['departure_date'];
    arrivalDate = json['arrival_date'];
    destinationWarehouse = json['destination_warehouse'];
    itemType =
        List.from(json['item_type']).map((e) => ItemType.fromJson(e)).toList();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sid = json['sid'];
    status = json['status'];
    permissionStatus =
        json['permission_status'] == null ? "" : json['permission_status'];
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
    _data['destination_warehouse'] = destinationWarehouse;
    _data['item_type'] = itemType.map((e) => e.toJson()).toList();
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['sid'] = sid;
    _data['status'] = status;
    _data['permission_status'] = permissionStatus;
    _data['booking_id'] = bookingId;
    return _data;
  }
}

class ItemType {
  ItemType({
    this.itemType,
    required this.categoryName,
    required this.icon,
    this.shippingFee,
    required this.pickupFee,
    this.quantity,
  });
  late final String? itemType;
  late final String categoryName;
  late final String icon;
  late final int? shippingFee;
  late final int pickupFee;
  late final int? quantity;

  ItemType.fromJson(Map<String, dynamic> json) {
    itemType = null;
    categoryName = json['category_name'];
    icon = json['icon'] == null ? "" : json['icon'];
    shippingFee = null;
    pickupFee = json['pickup_fee'];
    quantity = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['item_type'] = itemType;
    _data['category_name'] = categoryName;
    _data['icon'] = icon;
    _data['shipping_fee'] = shippingFee;
    _data['pickup_fee'] = pickupFee;
    _data['quantity'] = quantity;
    return _data;
  }
}
