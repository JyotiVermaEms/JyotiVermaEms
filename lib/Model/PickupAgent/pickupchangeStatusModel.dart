class PickupMarketChangeStatusModel {
  PickupMarketChangeStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<MarketStatusData> data;

  PickupMarketChangeStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => MarketStatusData.fromJson(e))
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

class MarketStatusData {
  MarketStatusData({
    required this.status,
    required this.departureImage,
    required this.departureComment,
    required this.arrivalImage,
    required this.pickupItemimage,
    required this.pickupItemimage1,
  });
  late final String status;
  late final String departureImage;
  late final String departureComment;
  late final String arrivalImage;
  late final String pickupItemimage;
  late final String pickupItemimage1;

  MarketStatusData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    departureImage =
        json['departure_image'] == null ? "" : json['departure_image'];
    departureComment =
        json['departure_comment'] == null ? "" : json['departure_comment'];
    arrivalImage = json['arrival_image'] == null ? "" : json['arrival_image'];
    pickupItemimage =
        json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
    pickupItemimage1 =
        json['pickup_itemimage1'] == null ? "" : json['pickup_itemimage1'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['departure_image'] = departureImage;
    _data['departure_comment'] = departureComment;
    _data['arrival_image'] = arrivalImage;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['pickup_itemimage1'] = pickupItemimage1;
    return _data;
  }
}

// =======================================//==========
class ArrivalMarketChangeStatusModel {
  ArrivalMarketChangeStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ArrivalMarketChangeStatusModel.fromJson(Map<String, dynamic> json) {
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
    required this.status,
    required this.arrivalImage,
    required this.arrivalComment,
    required this.departureImage,
    required this.pickupItemimage,
    required this.pickupItemimage1,
  });
  late final String status;
  late final String arrivalImage;
  late final String arrivalComment;
  late final String departureImage;
  late final String pickupItemimage;
  late final String pickupItemimage1;

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    arrivalImage = json['arrival_image'] == null ? "" : json['arrival_image'];
    arrivalComment =
        json['arrival_comment'] == null ? "" : json['arrival_comment'];
    departureImage =
        json['departure_image'] == null ? "" : json['departure_image'];
    pickupItemimage =
        json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
    pickupItemimage1 =
        json['pickup_itemimage1'] == null ? "" : json['pickup_itemimage1'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['arrival_image'] = arrivalImage;
    _data['arrival_comment'] = arrivalComment;
    _data['departure_image'] = departureImage;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['pickup_itemimage1'] = pickupItemimage1;
    return _data;
  }
}
