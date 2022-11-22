class SaveCardModel {
  SaveCardModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  SaveCardModel.fromJson(Map<String, dynamic> json) {
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
    required this.name,
    required this.cardNumber,
    required this.expire,
    required this.cvv,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String name;
  late final String cardNumber;
  late final String expire;
  late final String cvv;
  late final String updatedAt;
  late final String createdAt;
  late final int id;

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cardNumber = json['card_number'];
    expire = json['expire'];
    cvv = json['cvv'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['card_number'] = cardNumber;
    _data['expire'] = expire;
    _data['cvv'] = cvv;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}
