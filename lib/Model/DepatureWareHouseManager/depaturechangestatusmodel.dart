class DepatureChangeStatusModel {
  DepatureChangeStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<DepatureStatusData> data;

  DepatureChangeStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => DepatureStatusData.fromJson(e))
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

class DepatureStatusData {
  DepatureStatusData({
    required this.booking,
    required this.schedule,
  });
  late final List<Booking> booking;
  late final Schedule schedule;

  DepatureStatusData.fromJson(Map<String, dynamic> json) {
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
    required this.departureImage,
    required this.departureComment,
    this.pickupItemimage,
    this.pickupItemimage1,
  });
  late final String status;
  late final String departureImage;
  late final String departureComment;
  late final Null pickupItemimage;
  late final Null pickupItemimage1;

  Booking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    departureImage =
        json['departure_image'] == null ? "" : json['departure_image'];
    departureComment = json['departure_comment'];
    pickupItemimage = null;
    pickupItemimage1 = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['departure_image'] = departureImage;
    _data['departure_comment'] = departureComment;
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

//==============
class AcceptProposalStatusModel {
  AcceptProposalStatusModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<ProposalData> data;

  AcceptProposalStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        List.from(json['data']).map((e) => ProposalData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ProposalData {
  ProposalData({
    required this.id,
  });
  late final int id;

  ProposalData.fromJson(Map<String, dynamic> json) {
    id = json['marketbooking_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['marketbooking_id'] = id;
    return _data;
  }
}
