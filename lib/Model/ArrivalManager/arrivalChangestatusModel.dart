// class ArrivalChangeStatusModel {
//   ArrivalChangeStatusModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//   late final bool status;
//   late final String message;
//   late final List<ArrivalChangeStatusData> data;

//   ArrivalChangeStatusModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = List.from(json['data']).map((e) => ArrivalChangeStatusData.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['message'] = message;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class ArrivalChangeStatusData {
//   ArrivalChangeStatusData({
//     required this.booking,
//     required this.schedule,
//   });
//   late final Booking booking;
//   late final Schedule schedule;

//   ArrivalChangeStatusData.fromJson(Map<String, dynamic> json) {
//     booking = Booking.fromJson(json['booking']);
//     schedule = Schedule.fromJson(json['schedule']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['booking'] = booking.toJson();
//     _data['schedule'] = schedule.toJson();
//     return _data;
//   }
// }

// class Booking {
//   Booking({
//     required this.status,
//   });
//   late final String status;

//   Booking.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     return _data;
//   }
// }

// class Schedule {
//   Schedule({
//     required this.status,
//   });
//   late final String status;

//   Schedule.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     return _data;
//   }
// }
class ArrivalChangeStatusModel {
  ArrivalChangeStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<ArrivalChangeStatusData> data;

  ArrivalChangeStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => ArrivalChangeStatusData.fromJson(e))
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

class ArrivalChangeStatusData {
  ArrivalChangeStatusData({
    required this.booking,
    required this.schedule,
  });
  late final List<Booking> booking;
  late final Schedule schedule;

  ArrivalChangeStatusData.fromJson(Map<String, dynamic> json) {
    booking =
        List.from(json['booking']).map((e) => Booking.fromJson(e)).toList();
    schedule = Schedule.fromJson(json['schedule']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['booking'] = booking.map((e) => e.toJson()).toList();
    _data['schedule'] = schedule.toJson();
    return _data;
  }
}

class Booking {
  Booking({
    required this.status,
    this.arrivalImage,
    required this.arrivalComment,
    this.departureImage,
    this.pickupItemimage,
    this.pickupItemimage1,
  });
  late final String status;
  late final Null arrivalImage;
  late final String arrivalComment;
  late final Null departureImage;
  late final Null pickupItemimage;
  late final Null pickupItemimage1;

  Booking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    arrivalImage = null;
    arrivalComment = json['arrival_comment'];
    departureImage = null;
    pickupItemimage = null;
    pickupItemimage1 = null;
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

// ======================================
class ReceptionistChangStatusModel {
  ReceptionistChangStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<ReceptionistChangStatusData> data;

  ReceptionistChangStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => ReceptionistChangStatusData.fromJson(e))
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

class ReceptionistChangStatusData {
  ReceptionistChangStatusData({
    required this.status,
    required this.receptionistImage,
    required this.receptionistComment,
  });
  late final String status;
  late final String receptionistImage;
  late final String receptionistComment;

  ReceptionistChangStatusData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    receptionistImage = json['receptionist_image'];
    receptionistComment = json['receptionist_comment'] == null
        ? ""
        : json['receptionist_comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['receptionist_image'] = receptionistImage;
    _data['receptionist_comment'] = receptionistComment;
    return _data;
  }
}
