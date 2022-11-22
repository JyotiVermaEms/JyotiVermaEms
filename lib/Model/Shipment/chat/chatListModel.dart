class ChatListModel {
  late final bool status;
  late final int statusCode;
  late final String message;
  late final int error;

  late final List<ChatListResponse> data;

  ChatListModel(
      {required this.status,
      required this.statusCode,
      required this.message,
      required this.error,
      required this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    print("-=-=-= json $json");
    status = json['success'];
    // statusCode = json['statusCode'];
    message = json['message'];
    // error = json['error'];
    if (json['data'] != null) {
      data = <ChatListResponse>[];
      json['data'].forEach((v) {
        data.add(ChatListResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatListResponse {
  late final int byuserdeletestatus;
  late final String email;
  late final String fullName;
  late final String lastMessageDate;
  late final String lastMessageTime;
  late final String lastMessage;
  late final String lastMessageType;
  late final int roomId;
  late final int sid;

  late final int tobydeletestatus;
  late final String updatedAt;
  late final int userBy;
  late final String userByRole;
  late final int userId;
  late final int userTo;
  late final String userToRole;
  late final String profileimage;
  late final String groupName;
  late final List<MemberList> memberList;

  ChatListResponse({
    required this.byuserdeletestatus,
    required this.email,
    required this.fullName,
    required this.lastMessageDate,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.lastMessageType,
    required this.roomId,
    required this.sid,
    required this.tobydeletestatus,
    required this.updatedAt,
    required this.userBy,
    required this.userByRole,
    required this.userId,
    required this.userTo,
    required this.userToRole,
    required this.profileimage,
    required this.groupName,
    required this.memberList,
  });

  ChatListResponse.fromJson(Map<String, dynamic> json) {
    byuserdeletestatus = json['byuserdeletestatus'];

    email = json['email'];
    fullName = json['full_name'];

    lastMessageDate = json['lastMessage_Date'];
    lastMessageTime = json['lastMessage_Time'];
    lastMessage = json['last_message'];
    lastMessageType = json['last_message_type'];
    roomId = json['room_id'];
    sid = json['sid'];

    tobydeletestatus = json['tobydeletestatus'];
    updatedAt = json['updated_At'];
    userBy = json['userBy'];
    userByRole = json['userByRole'];
    userId = json['userId'];
    userTo = json['userTo'];
    userToRole = json['userToRole'];
    profileimage = json['profileimage'];
    groupName = json['group_name'];
    memberList = List.from(json['membersData'])
        .map((e) => MemberList.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['byuserdeletestatus'] = this.byuserdeletestatus;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['lastMessage_Date'] = this.lastMessageDate;
    data['lastMessage_Time'] = this.lastMessageTime;
    data['last_message'] = this.lastMessage;
    data['last_message_type'] = this.lastMessageType;
    data['room_id'] = this.roomId;
    data['sid'] = this.sid;
    data['tobydeletestatus'] = this.tobydeletestatus;
    data['updated_At'] = this.updatedAt;
    data['userBy'] = this.userBy;
    data['userByRole'] = this.userByRole;
    data['userId'] = this.userId;
    data['userTo'] = this.userTo;
    data['userToRole'] = this.userToRole;
    data['profileimage'] = this.profileimage;
    data['group_name'] = this.groupName;
    data['membersData'] = memberList.map((e) => e.toJson()).toList();

    return data;
  }
}

class MemberList {
  MemberList({
    required this.fullName,
    required this.email,
    required this.profileimage,
  });
  late final String fullName;
  late final String email;
  late final String profileimage;

  MemberList.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    profileimage = json['profileimage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['full_name'] = fullName;
    _data['email'] = email;
    _data['profileimage'] = profileimage;

    return _data;
  }
}
