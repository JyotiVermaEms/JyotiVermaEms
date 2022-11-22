class GetPriceModel {
  GetPriceModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  GetPriceModel.fromJson(Map<String, dynamic> json) {
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
    required this.itemName,
    required this.itemQuantity,
    required this.categoryId,
    required this.available,
    required this.pickupFee,
    required this.shippingFee,
    required this.createdAt,
    required this.updatedAt,
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemQuantity = json['item_quantity'];
    categoryId = json['category_id'];
    available = json['available'];
    pickupFee = json['pickup_fee'];
    shippingFee = json['shipping_fee'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return _data;
  }
}
