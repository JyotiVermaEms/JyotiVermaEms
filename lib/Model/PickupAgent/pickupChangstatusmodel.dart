class RecepChangStatusMode {
  RecepChangStatusMode({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<StatusData> data;

  RecepChangStatusMode.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => StatusData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class StatusData {
  StatusData({
    required this.status,
    required this.pickupItemimage,
    required this.pickupComment,
  });
  late final String status;
  late final String pickupItemimage;
  late final String pickupComment;

  StatusData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pickupItemimage =
        json['pickup_itemimage'] == null ? "" : json['pickup_itemimage'];
    pickupComment =
        json['pickup_comment'] == null ? "" : json['pickup_comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['pickup_itemimage'] = pickupItemimage;
    _data['pickup_comment'] = pickupComment;
    return _data;
  }
}
