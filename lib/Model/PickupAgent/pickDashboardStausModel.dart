class PickupDashboardStatus {
  PickupDashboardStatus({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<pickstatusData> data;

  PickupDashboardStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        List.from(json['data']).map((e) => pickstatusData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class pickstatusData {
  pickstatusData({
    required this.pickupOrders,
    required this.goingToPickup,
    required this.pickupDone,
    required this.assignOrders,
    required this.completedOrders,
  });
  late final int pickupOrders;
  late final int goingToPickup;
  late final int pickupDone;
  late final int assignOrders;
  late final int completedOrders;

  pickstatusData.fromJson(Map<String, dynamic> json) {
    pickupOrders = json['pickup_orders'];
    goingToPickup = json['going_to_pickup'];
    pickupDone = json['pickup_done'];
    assignOrders = json['assign_orders'] == null ? 0 : json['assign_orders'];
    completedOrders = json['completed_orders'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pickup_orders'] = pickupOrders;
    _data['going_to_pickup'] = goingToPickup;
    _data['pickup_done'] = pickupDone;
    _data['assignOrders'] = assignOrders;
    _data['assign_orders'] = completedOrders;
    return _data;
  }
}
