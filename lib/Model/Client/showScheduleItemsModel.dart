// class ShowScheduleItemsModel {
//   ShowScheduleItemsModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//   late final bool status;
//   late final String message;
//   late final List<Data> data;

//   ShowScheduleItemsModel.fromJson(Map<String, dynamic> json) {
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
//     required this.id,
//     required this.categoryName,
//     required this.items,
//   });
//   late final int id;
//   late final String categoryName;
//   late final List<Items> items;

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryName = json['category_name'];
//     items = List.from(json['items']).map((e) => Items.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['category_name'] = categoryName;
//     _data['items'] = items.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class Items {
//   Items({
//     required this.itemName,
//     required this.category,
//   });
//   late final String itemName;
//   late final int category;

//   Items.fromJson(Map<String, dynamic> json) {
//     itemName = json['item_name'];
//     category = json['category'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['item_name'] = itemName;
//     _data['category'] = category;
//     return _data;
//   }
// }
import 'package:flutter/src/material/popup_menu.dart';

class ShowScheduleItemsModel {
  bool? status;
  String? message;
  List<ShowScheduleItemsModelData>? data;

  ShowScheduleItemsModel({this.status, this.message, this.data});

  ShowScheduleItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShowScheduleItemsModelData>[];
      json['data'].forEach((v) {
        data!.add(new ShowScheduleItemsModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShowScheduleItemsModelData {
  int? id;
  String? categoryName;
  String? item;
  int? shippingFee;
  int? pickupFee;
  int? quantity;
  String? icon;
  List<Items>? items;

  ShowScheduleItemsModelData(
      {this.id,
      this.categoryName,
      this.item,
      this.shippingFee,
      this.pickupFee,
      this.quantity,
      this.icon,
      this.items});

  ShowScheduleItemsModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category'];
    item = json['item'];
    icon = json['icon'];
    shippingFee = json['shipping_fee'];
    pickupFee = json['pickup_fee'];
    quantity = json['quantity'];
    if (json['item_name'] != null) {
      items = <Items>[];
      json['item_name'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  // scheduleItemId = json['schedule_item_id'];

  // category = json['category'];
  // sid = json['sid'];
  // itemName = List.castFrom<dynamic, String>(json['item_name']);

  // if (json['item_name'] != null) {
  //   itemName = <Items>[];
  //   json['item_name'].forEach((v) {
  //     itemName!.add(new Items.fromJson(v));
  //   });
  // }

  // categoryName = json['category_name'];
  // item = json['item'];
  // icon = json['icon'];
  // shippingFee = json['shipping_fee'];
  // pickupFee = json['pickup_fee'];
  // quantity = json['quantity'];
  // if (json['items'] != null) {
  //   items = <Items>[];
  //   json['items'].forEach((v) {
  //     items!.add(new Items.fromJson(v));
  //   });
  // }
  // }
  // Map<String, dynamic> toJson() {
  //   final _data = <String, dynamic>{};
  //   _data['id'] = id;
  //   _data['schedule_item_id'] = scheduleItemId;
  //   _data['item_name'] = itemName;
  //   _data['category'] = category;
  //   _data['sid'] = sid;
  //   return _data;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['item'] = this.item;
    data['shipping_fee'] = this.shippingFee;
    data['pickup_fee'] = this.pickupFee;
    data['quantity'] = this.quantity;
    data['icon'] = this.icon;
    if (this.items != null) {
      data['item_name'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? itemName;
  bool? statusItem;

  Items({this.itemName, this.statusItem});

  Items.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    statusItem = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['statusItem'] = this.statusItem;
    return data;
  }

  map(PopupMenuItem<String> Function(Items value) param0) {}
}
