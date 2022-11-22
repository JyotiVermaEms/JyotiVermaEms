//=======send broadcst message
class SendBroadcastMessageModel {
  bool? status;
  String? message;
  List<SendBroadcastData>? data;

  SendBroadcastMessageModel({this.status, this.message, this.data});

  SendBroadcastMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SendBroadcastData>[];
      json['data'].forEach((v) {
        data!.add(new SendBroadcastData.fromJson(v));
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

class SendBroadcastData {
  String? scheduleId;
  int? sid;
  String? users;
  String? title;
  String? scheduleTitle;
  String? message;
  String? updatedAt;
  String? createdAt;
  int? id;

  SendBroadcastData(
      {this.scheduleId,
      this.sid,
      this.users,
      this.title,
      this.scheduleTitle,
      this.message,
      this.updatedAt,
      this.createdAt,
      this.id});

  SendBroadcastData.fromJson(Map<String, dynamic> json) {
    scheduleId = json['schedule_id'];
    sid = json['sid'];
    users = json['users'];
    title = json['title'];
    scheduleTitle = json['schedule_title'];
    message = json['message'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_id'] = this.scheduleId;
    data['sid'] = this.sid;
    data['users'] = this.users;
    data['title'] = this.title;
    data['schedule_title'] = this.scheduleTitle;
    data['message'] = this.message;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

//=======get broadcst message

class GetBroadcastMessageModel {
  bool? status;
  String? message;
  List<GetBroadcastData>? data;

  GetBroadcastMessageModel({this.status, this.message, this.data});

  GetBroadcastMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetBroadcastData>[];
      json['data'].forEach((v) {
        data!.add(new GetBroadcastData.fromJson(v));
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

class GetBroadcastData {
  int? id;
  int? scheduleId;
  int? sid;
  List<Users>? users;
  String? title;
  String? scheduleTitle;
  String? message;
  String? createdAt;
  String? updatedAt;
  String? shipmentprofile;

  GetBroadcastData(
      {this.id,
      this.scheduleId,
      this.sid,
      this.users,
      this.title,
      this.scheduleTitle,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.shipmentprofile});

  GetBroadcastData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleId = json['schedule_id'];
    sid = json['sid'];
    shipmentprofile = json['shipmentprofile'] ?? "";
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    title = json['title'];
    scheduleTitle = json['schedule_title'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['schedule_id'] = this.scheduleId;
    data['sid'] = this.sid;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['schedule_title'] = this.scheduleTitle;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['shipmentprofile'] = this.shipmentprofile;

    return data;
  }
}

class Users {
  int? uid;
  String? name;
  String? image;

  Users({this.uid, this.name, this.image});

  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    image = json['profile'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['profile'] = this.image;

    return data;
  }
}
