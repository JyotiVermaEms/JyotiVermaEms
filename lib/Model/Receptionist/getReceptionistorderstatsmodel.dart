class ResceptionistDahboardStatsModel {
  ResceptionistDahboardStatsModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<receptStatsdData> data;

  ResceptionistDahboardStatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => receptStatsdData.fromJson(e))
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

class receptStatsdData {
  receptStatsdData({
    required this.totalOrders,
    required this.assignOrders,
    required this.deliverToDeparture,
    required this.deliverToArrival,
    required this.completedOrders,
  });
  late final int totalOrders;
  late final int assignOrders;
  late final int deliverToDeparture;
  late final int deliverToArrival;
  late final int completedOrders;

  receptStatsdData.fromJson(Map<String, dynamic> json) {
    totalOrders = json['total_orders'] == null ? "" : json['total_orders'];
    assignOrders = json['assign_orders'] == null ? "" : json['assign_orders'];
    deliverToDeparture = json['deliver_to_departure'] == null
        ? ""
        : json['deliver_to_departure'];
    deliverToArrival =
        json['deliver_to_arrival'] == null ? "" : json['deliver_to_arrival'];
    completedOrders =
        json['completed_orders'] == null ? "" : json['completed_orders'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_orders'] = totalOrders;
    _data['assign_orders'] = assignOrders;
    _data['deliver_to_departure'] = deliverToDeparture;
    _data['deliver_to_arrival'] = deliverToArrival;
    _data['completed_orders'] = completedOrders;
    return _data;
  }
}
