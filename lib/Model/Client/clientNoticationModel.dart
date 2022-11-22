class ClientNotificationModel {
  ClientNotificationModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<ClientNotificationData> data;

  ClientNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => ClientNotificationData.fromJson(e))
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

class ClientNotificationData {
  ClientNotificationData({
    required this.id,
    required this.msg,
    required this.title,
    required this.uid,
    required this.sid,
    required this.bookingId,
    required this.scheduleId,
    required this.marketId,
    required this.isAdmin,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String msg;
  late final String title;
  late final int uid;
  late final int sid;
  late final int bookingId;
  late final int scheduleId;
  late final int marketId;
  late final int isAdmin;
  late final int status;
  late final String createdAt;
  late final String updatedAt;

  ClientNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    title = json['title'];
    uid = json['uid'];
    sid = json['sid'];
    bookingId = json['booking_id'];
    scheduleId = json['schedule_id'];
    marketId = json['market_id'];
    isAdmin = json['is_admin'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['msg'] = msg;
    _data['title'] = title;
    _data['uid'] = uid;
    _data['sid'] = sid;
    _data['booking_id'] = bookingId;
    _data['schedule_id'] = scheduleId;
    _data['market_id'] = marketId;
    _data['is_admin'] = isAdmin;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
