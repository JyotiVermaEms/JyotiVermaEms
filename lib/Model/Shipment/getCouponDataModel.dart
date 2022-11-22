class GetCouponDataModel {
  GetCouponDataModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  GetCouponDataModel.fromJson(Map<String, dynamic> json) {
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
    required this.couponName,
    required this.couponCode,
    required this.couponDescription,
    required this.couponType,
    required this.couponAmount,
    required this.once,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.finalAmount,
  });
  late final int id;
  late final String couponName;
  late final String couponCode;
  late final String couponDescription;
  late final String couponType;
  late final String couponAmount;
  late final int once;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final String finalAmount;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponName = json['coupon_name'];
    couponCode = json['coupon_code'];
    couponDescription = json['coupon_description'];
    couponType = json['coupon_type'];
    couponAmount = json['coupon_amount'];
    once = json['once'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    finalAmount = json['final_amount'] == null ? "" : json['final_amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['coupon_name'] = couponName;
    _data['coupon_code'] = couponCode;
    _data['coupon_description'] = couponDescription;
    _data['coupon_type'] = couponType;
    _data['coupon_amount'] = couponAmount;
    _data['once'] = once;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['final_amount'] = finalAmount;
    return _data;
  }
}
