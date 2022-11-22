class CreateRoomModel {
  late final bool status;
  late final String message;

  late final List<CreateRoomResponse1> data;

  CreateRoomModel(
      {required this.status, required this.message, required this.data});

  CreateRoomModel.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CreateRoomResponse1>[];
      json['data'].forEach((v) {
        print("-=-=vv $v");
        data.add(CreateRoomResponse1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    print("-->>> ${this.data}");
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreateRoomResponse1 {
  late final int roomId;
  late final int sid;
  late final int userTo;
  late final int userBy;
  late final String userToRole;
  late final String userByRole;
  late final String date;
  late final String time;
  late final String lastMessage;
  late final String lastMessageType;
  late final int lastJobId;
  late final String createdAt;
  late final String updatedAt;
  late final String lastMessageDate;
  late final String lastMessageTime;
  late final int tobydeletestatus;
  late final int byuserdeletestatus;

  CreateRoomResponse1({
    required this.roomId,
    required this.sid,
    required this.userTo,
    required this.userBy,
    required this.userToRole,
    required this.userByRole,
    required this.date,
    required this.time,
    required this.lastMessage,
    required this.lastMessageType,
    required this.lastJobId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessageDate,
    required this.lastMessageTime,
    required this.tobydeletestatus,
    required this.byuserdeletestatus,
  });

  CreateRoomResponse1.fromJson(Map<String, dynamic> json) {
    print("-=-json $json");
    roomId = json['room_id'];
    sid = json['sid'];

    userTo = json['userTo'];
    userBy = json['userBy'];
    userToRole = json['userToRole'];
    userByRole = json['userByRole'];
    date = json['date'];
    time = json['time'];

    lastMessage = json['last_message'];
    lastMessageType = json['last_message_type'];
    lastJobId = json['last_job_id'];
    createdAt = json['created_At'];
    updatedAt = json['updated_At'];
    lastMessageDate = json['lastMessage_Date'];
    lastMessageTime = json['lastMessage_Time'];
    tobydeletestatus = json['tobydeletestatus'];
    byuserdeletestatus = json['byuserdeletestatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['sid'] = this.sid;
    data['userTo'] = this.userTo;
    data['userBy'] = this.userBy;
    data['userToRole'] = this.userToRole;
    data['userByRole'] = this.userByRole;
    data['date'] = this.date;
    data['time'] = this.time;
    data['last_message'] = this.lastMessage;

    data['last_message_type'] = this.lastMessageType;
    data['last_job_id'] = this.lastJobId;
    data['created_At'] = this.createdAt;
    data['updated_At'] = this.updatedAt;
    data['lastMessage_Date'] = this.lastMessageDate;
    data['lastMessage_Time'] = this.lastMessageTime;
    data['tobydeletestatus'] = this.tobydeletestatus;
    data['byuserdeletestatus'] = this.byuserdeletestatus;

    print("-=-=-data $data");
    return data;
  }
}

//==========add group member model
class AddGroupMemberModel {
  bool? success;
  String? message;
  // List<Null>? data;

  AddGroupMemberModel({this.success, this.message});

  AddGroupMemberModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    // if (json['data'] != null) {
    //   data = <Null>[];
    //   json['data'].forEach((v) {
    //     data!.add( Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
