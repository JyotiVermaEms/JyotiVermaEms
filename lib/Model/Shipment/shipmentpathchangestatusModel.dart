class ShipmentChangeStatusModel {
  ShipmentChangeStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ShipmentChangeStatusModel.fromJson(Map<String, dynamic> json) {
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
    required this.booking,
    required this.schedule,
  });
  late final Booking booking;
  late final Schedule schedule;

  Data.fromJson(Map<String, dynamic> json) {
    booking = Booking.fromJson(json['booking']);
    schedule = Schedule.fromJson(json['schedule']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['booking'] = booking.toJson();
    _data['schedule'] = schedule.toJson();
    return _data;
  }
}

class Booking {
  Booking({
    required this.status,
  });
  late final String status;

  Booking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    return _data;
  }
}

class Schedule {
  Schedule({
    required this.status,
  });
  late final String status;

  Schedule.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    return _data;
  }
}
