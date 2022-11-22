// class GetScheduleItemModel {
//   GetScheduleItemModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//   late final bool status;
//   late final String message;
//   late final List<Data> data;

//   GetScheduleItemModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['message'] = message;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.itemType,
//     required this.categoryName,
//     required this.icon,
//     required this.shippingFee,
//     required this.pickupFee,
//     required this.quantity,
//   });
//   late final String itemType;
//   late final String categoryName;
//   late final String icon;
//   late final int shippingFee;
//   late final int pickupFee;
//   late final int quantity;
//   late bool key = false;

//   Data.fromJson(Map<String, dynamic> json) {
//     itemType = json['item_type'] ?? "";
//     categoryName = json['category_name'];
//     icon = json['icon'] ?? "";
//     shippingFee = json['shipping_fee'] ?? 0;
//     pickupFee = json['pickup_fee'] ?? 0;
//     quantity = json['quantity'] ?? 0;
//     key = false;
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['item_type'] = itemType;
//     _data['key'] = key;

//     _data['category_name'] = categoryName;
//     _data['icon'] = icon;
//     _data['shipping_fee'] = shippingFee;
//     _data['pickup_fee'] = pickupFee;
//     _data['quantity'] = quantity;
//     return _data;
//   }
// }
class GetScheduleItemModel {
  GetScheduleItemModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  GetScheduleItemModel.fromJson(Map<String, dynamic> json) {
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
    required this.itemId,
    this.icon,
    this.itemNumber,
    required this.scheduleId,
    required this.createdAt,
    required this.updatedAt,
    this.available,
    required this.item,
  });
  late final int id;
  late final String itemId;
  late final Null icon;
  late final Null itemNumber;
  late final String scheduleId;
  late final String createdAt;
  late final String updatedAt;
  late final String? available;
  late final List<Item> item;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    icon = null;
    itemNumber = null;
    scheduleId = json['schedule_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    available = null;
    item = List.from(json['item']).map((e) => Item.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['item_id'] = itemId;
    _data['icon'] = icon;
    _data['item_number'] = itemNumber;
    _data['schedule_id'] = scheduleId;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['available'] = available;
    _data['item'] = item.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Item {
  Item({
    required this.id,
    required this.itemName,
    required this.itemQuantity,
    required this.categoryId,
    required this.available,
    required this.pickupFee,
    required this.shippingFee,
    required this.createdAt,
    required this.updatedAt,
    required this.key,
  });
  late final int id;
  late final String itemName;
  late final String itemQuantity;
  late final int categoryId;
  late final String available;
  late final String pickupFee;
  late final String shippingFee;
  late final String createdAt;
  late final String updatedAt;
  late bool key = false;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemQuantity = json['item_quantity'];
    categoryId = json['category_id'];
    available = json['available'];
    pickupFee = json['pickup_fee'];
    shippingFee = json['shipping_fee'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  key = false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['item_name'] = itemName;
    _data['item_quantity'] = itemQuantity;
    _data['category_id'] = categoryId;
    _data['available'] = available;
    _data['pickup_fee'] = pickupFee;
    _data['shipping_fee'] = shippingFee;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['key'] = key;
    return _data;
  }
}
