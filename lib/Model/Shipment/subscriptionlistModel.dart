class SubscriptionListModel {
  SubscriptionListModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<subscriptionData> data;

  SubscriptionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => subscriptionData.fromJson(e))
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

class subscriptionData {
  subscriptionData({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String price;
  late final String duration;
  late final List<Description> description;
  late final String createdAt;
  late final String updatedAt;

  subscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    description = List.from(json['description'])
        .map((e) => Description.fromJson(e))
        .toList();
    createdAt = json['created_at'] == null ? "" : json['created_at'];
    updatedAt = json['updated_at'] == null ? "" : json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['duration'] = duration;
    _data['description'] = description.map((e) => e.toJson()).toList();
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class Description {
  Description({
    required this.feature,
  });
  late final String feature;

  Description.fromJson(Map<String, dynamic> json) {
    feature = json['feature'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['feature'] = feature;
    return _data;
  }
}
