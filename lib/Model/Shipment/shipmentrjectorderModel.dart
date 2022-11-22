class ShipmentRejectModel {
  ShipmentRejectModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<dynamic> data;

  ShipmentRejectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        List.castFrom<String, dynamic>(json['data'] == null ? "" : json[data]);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data;
    return _data;
  }
}
