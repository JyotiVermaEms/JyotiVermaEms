class DepatureStatsModel {
  DepatureStatsModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<DStatsData> data;

  DepatureStatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => DStatsData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DStatsData {
  DStatsData({
    required this.totalSchedules,
    required this.closedSchedules,
    required this.openSchedules,
    required this.inprogressSchedules,
    required this.packedSchedules,
    required this.totalClient,
  });
  late final int totalSchedules;
  late final int closedSchedules;
  late final int openSchedules;
  late final int inprogressSchedules;
  late final int packedSchedules;
  late final int totalClient;

  DStatsData.fromJson(Map<String, dynamic> json) {
    totalSchedules = json['total_schedules'];
    closedSchedules = json['closed_schedules'];
    openSchedules = json['open_schedules'];
    inprogressSchedules = json['inprogress_schedules'];
    packedSchedules =
        json['packed_schedules'] == null ? "" : json['packed_schedules'];
    totalClient = json['total_client'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_schedules'] = totalSchedules;
    _data['closed_schedules'] = closedSchedules;
    _data['open_schedules'] = openSchedules;
    _data['inprogress_schedules'] = inprogressSchedules;
    _data['packed_schedules'] = packedSchedules;
    _data['total_client'] = totalClient;
    return _data;
  }
}
