class DepatureSearchTileModel {
  DepatureSearchTileModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<SearchD> data;

  DepatureSearchTileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => SearchD.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SearchD {
  SearchD({
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
    required this.available,
    required this.totalContainer,
    required this.availableContainer,
    required this.rating,
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
  late final List<ItemType> itemType;
  late final String createdAt;
  late final String updatedAt;
  late final int sid;
  late final String status;
  late final String permissionStatus;
  late final int bookingId;
  late final List<Available> available;
  late final int totalContainer;
  late final int availableContainer;
  late final double rating;

  SearchD.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shipmentType = json['shipment_type'];
    from = json['from'];
    to = json['to'];
    departureDate = json['departure_date'];
    arrivalDate = json['arrival_date'];
    departureWarehouse = json['departure_warehouse'];
    destinationWarehouse = json['destination_warehouse'];
    itemType =
        List.from(json['item_type']).map((e) => ItemType.fromJson(e)).toList();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sid = json['sid'];
    status = json['status'];
    permissionStatus = json['permission_status'];
    bookingId = json['booking_id'];
    available =
        List.from(json['available']).map((e) => Available.fromJson(e)).toList();
    totalContainer = json['total_container'];
    availableContainer = json['available_container'];
    rating = json['rating'];
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
    _data['item_type'] = itemType.map((e) => e.toJson()).toList();
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['sid'] = sid;
    _data['status'] = status;
    _data['permission_status'] = permissionStatus;
    _data['booking_id'] = bookingId;
    _data['available'] = available.map((e) => e.toJson()).toList();
    _data['total_container'] = totalContainer;
    _data['available_container'] = availableContainer;
    _data['rating'] = rating;
    return _data;
  }
}

class ItemType {
  ItemType({
    this.itemType,
    required this.categoryName,
    this.icon,
    this.shippingFee,
    required this.pickupFee,
    this.quantity,
  });
  late final String? itemType;
  late final String categoryName;
  late final Null icon;
  late final int? shippingFee;
  late final int pickupFee;
  late final int? quantity;

  ItemType.fromJson(Map<String, dynamic> json) {
    itemType = null;
    categoryName = json['category_name'];
    icon = null;
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

class Available {
  Available({
    required this.category,
    this.available,
  });
  late final String category;
  late final String? available;

  Available.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    available = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    _data['available'] = available;
    return _data;
  }
}
