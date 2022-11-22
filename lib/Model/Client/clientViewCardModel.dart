class ViewCardModel {
  ViewCardModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ViewCardModel.fromJson(Map<String, dynamic> json) {
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
    required this.uid,
    required this.name,
    required this.cardNumber,
    required this.expire,
    required this.cvv,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int uid;
  late final String name;
  late final String cardNumber;
  late final String expire;
  late final String cvv;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['name'];
    cardNumber = json['card_number'];
    expire = json['expire'];
    cvv = json['cvv'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['name'] = name;
    _data['card_number'] = cardNumber;
    _data['expire'] = expire;
    _data['cvv'] = cvv;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
