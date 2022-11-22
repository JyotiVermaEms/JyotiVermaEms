class ScheduleItemModel {
  ScheduleItemModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Schdule> data;

  ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Schdule.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Schdule {
  Schdule({
    required this.id,
    required this.scheduleItemId,
    required this.itemName,
    required this.category,
    required this.sid,
  });
  late final int id;
  late final String scheduleItemId;
  // late final List<ItemName> itemName;
  late final String category;
  late final int sid;
  late final List<Items> itemName;

  Schdule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleItemId = json['schedule_item_id'];
    itemName =
        List.from(json['item_name']).map((e) => Items.fromJson(e)).toList();
    category = json['category'];
    sid = json['sid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['schedule_item_id'] = scheduleItemId;
    _data['item_name'] = itemName.map((e) => e.toJson()).toList();
    _data['category'] = category;
    _data['sid'] = sid;
    return _data;
  }
}

class Items {
  Items({
    required this.itemName,
  });
  late final String itemName;

  Items.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['item_name'] = itemName;
    return _data;
  }
}
