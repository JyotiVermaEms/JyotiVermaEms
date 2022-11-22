class SendProposalModel {
  SendProposalModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  SendProposalModel.fromJson(Map<String, dynamic> json) {
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
    required this.uid,
    required this.sid,
    required this.mid,
    required this.proposals,
    required this.type,
    required this.pickupfee,
    required this.shippingPrice,
    required this.tax,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String uid;
  late final int sid;
  late final String mid;
  late final String proposals;
  late final String type;
  late final String pickupfee;
  late final String shippingPrice;
  late final String tax;
  late final String status;
  late final String updatedAt;
  late final String createdAt;
  late final int id;

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    sid = json['sid'];
    mid = json['mid'];
    proposals = json['proposals'];
    type = json['type'];
    pickupfee = json['pickupfee'];
    shippingPrice = json['shipping_price'];
    tax = json['tax'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['sid'] = sid;
    _data['mid'] = mid;
    _data['proposals'] = proposals;
    _data['type'] = type;
    _data['pickupfee'] = pickupfee;
    _data['shipping_price'] = shippingPrice;
    _data['tax'] = tax;
    _data['status'] = status;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}
