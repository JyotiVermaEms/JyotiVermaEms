class ShipmentStatsModel {
  ShipmentStatsModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<StatsData> data;

  ShipmentStatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => StatsData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class StatsData {
  StatsData({
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

  StatsData.fromJson(Map<String, dynamic> json) {
    totalSchedules =
        json['total_schedules'] == null ? "" : json['total_schedules'];
    closedSchedules =
        json['closed_schedules'] == null ? "" : json['closed_schedules'];
    packedSchedules =
        json['packed_schedules'] == null ? "" : json['packed_schedules'];
    openSchedules =
        json['open_schedules'] == null ? "" : json['open_schedules'];
    inprogressSchedules = json['inprogress_schedules'] == null
        ? ""
        : json['inprogress_schedules'];
    totalClient = json['total_client'] == null ? "" : json['total_client'];
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
