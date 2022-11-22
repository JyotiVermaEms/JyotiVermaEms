class ScheduleShipmentRes {
  bool? status;
  String? message;
  List<scheduleShipmentResData>? data;

  ScheduleShipmentRes({this.status, this.message, this.data});

  ScheduleShipmentRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <scheduleShipmentResData>[];
      json['data'].forEach((v) {
        data!.add(new scheduleShipmentResData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class scheduleShipmentResData {
  String? shipmentType;
  String? title;
  String? from;
  String? to;
  String? departureDate;
  String? arrivalDate;
  String? destinationWarehouse;
  String? itemType;
  int? sid;
  String? status;
  String? permissionStatus;
  String? updatedAt;
  String? createdAt;
  int? id;

  scheduleShipmentResData(
      {this.shipmentType,
      this.title,
      this.from,
      this.to,
      this.departureDate,
      this.arrivalDate,
      this.destinationWarehouse,
      this.itemType,
      this.sid,
      this.status,
      this.permissionStatus,
      this.updatedAt,
      this.createdAt,
      this.id});

  scheduleShipmentResData.fromJson(Map<String, dynamic> json) {
    shipmentType = json['shipment_type'];
    title = json['title'];
    from = json['from'];
    to = json['to'];
    departureDate = json['departure_date'];
    arrivalDate = json['arrival_date'];
    destinationWarehouse = json['destination_warehouse'];
    itemType = json['item_type'];
    sid = json['sid'];
    status = json['status'];
    permissionStatus = json['permission_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipment_type'] = this.shipmentType;
    data['title'] = this.title;
    data['from'] = this.from;
    data['to'] = this.to;
    data['departure_date'] = this.departureDate;
    data['arrival_date'] = this.arrivalDate;
    data['destination_warehouse'] = this.destinationWarehouse;
    data['item_type'] = this.itemType;
    data['sid'] = this.sid;
    data['status'] = this.status;
    data['permission_status'] = this.permissionStatus;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
