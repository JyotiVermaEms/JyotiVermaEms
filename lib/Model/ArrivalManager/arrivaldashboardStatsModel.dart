class ArrivalDashboardStatesModel {
  ArrivalDashboardStatesModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<ArrStData> data;

  ArrivalDashboardStatesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => ArrStData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ArrStData {
  ArrStData({
    required this.totalSchedules,
    required this.closedSchedules,
    required this.packedSchedules,
    required this.openSchedules,
    required this.inprogressSchedules,
    required this.totalClient,
  });
  late final int totalSchedules;
  late final int closedSchedules;
  late final int packedSchedules;
  late final int openSchedules;
  late final int inprogressSchedules;
  late final int totalClient;

  ArrStData.fromJson(Map<String, dynamic> json) {
    totalSchedules = json['total_schedules'];
    closedSchedules = json['closed_schedules'];
    packedSchedules = json['packed_schedules'];
    openSchedules = json['open_schedules'];
    inprogressSchedules = json['inprogress_schedules'];
    totalClient = json['total_client'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_schedules'] = totalSchedules;
    _data['closed_schedules'] = closedSchedules;
    _data['packed_schedules'] = packedSchedules;
    _data['open_schedules'] = openSchedules;
    _data['inprogress_schedules'] = inprogressSchedules;
    _data['total_client'] = totalClient;
    return _data;
  }
}
