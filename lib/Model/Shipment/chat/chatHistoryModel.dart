class ChatHistoryModel {
  late final bool status;
  late final int statusCode;
  late final String message;
  late final int error;

  late final List<Response> data;

  ChatHistoryModel(
      {required this.status,
      required this.statusCode,
      required this.message,
      required this.error,
      required this.data});

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    print("-=-=-= json $json");
    status = json['success'];
    // statusCode = json['statusCode'];
    message = json['message'];
    // error = json['error'];
    if (json['data'] != null) {
      data = <Response>[];
      json['data'].forEach((v) {
        data.add(Response.fromJson(v));
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

class Response {
  late final int messageId;
  late final String messageType;
  late final String message;
  late final String fullName;
  late final String email;
  late final int receiverId;
  late final int senderId;
  late final String date;
  late final String time;
  late final String? fileType;
  late final int jobStatus;
  late final int tobydeletestatus;
  late final int byuserdeletestatus;
  late final String createdAt;
  late final String updatedAt;
  late final String? file;
  late final String? sTitle;
  late final String? sImage;
  late final String? profileimage;

  late final int isread;
  late final String status;
  late final String senderType;
  late final String receiverType;

  late final int sid;
  late final int roomId;

  Response({
    required this.messageId,
    required this.messageType,
    required this.message,
    required this.roomId,
    required this.email,
    required this.fullName,
    required this.receiverId,
    required this.senderId,
    required this.date,
    required this.time,
    required this.fileType,
    required this.jobStatus,
    required this.tobydeletestatus,
    required this.byuserdeletestatus,
    required this.createdAt,
    required this.updatedAt,
    required this.isread,
    required this.status,
    required this.senderType,
    required this.receiverType,
    required this.sid,
    required this.file,
    required this.sTitle,
    required this.sImage,
    required this.profileimage,
  });

  Response.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    messageType = json['message_type'];
    message = json['message'];
    email = json['email'];
    fullName = json['full_name'];
    profileimage = json['profileimage'] ?? "";

    roomId = json['room_id'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    date = json['date'];
    time = json['time'];

    fileType = json['fileType'] ?? "";
    jobStatus = json['job_status'];
    tobydeletestatus = json['tobydeletestatus'];
    byuserdeletestatus = json['byuserdeletestatus'];
    createdAt = json['created_At'];
    updatedAt = json['updated_At'];
    isread = json['isread'];
    status = json['status'];
    senderType = json['sender_type'];
    receiverType = json['receiver_type'];
    sid = json['sid'];

    file = json['file'];
    sTitle = json['sTitle'];
    sImage = json['sImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = this.messageId;
    data['profileimage'] = this.profileimage;
    data['full_name'] = this.fullName;

    data['email'] = this.email;

    data['message_type'] = this.messageType;
    data['message'] = this.message;
    data['room_id'] = this.roomId;
    data['receiver_id'] = this.receiverId;
    data['sender_id'] = this.senderId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['fileType'] = this.fileType;
    data['job_status'] = this.jobStatus;
    data['tobydeletestatus'] = this.tobydeletestatus;
    data['byuserdeletestatus'] = this.byuserdeletestatus;

    data['created_At'] = this.createdAt;
    data['updated_At'] = this.updatedAt;
    data['isread'] = this.isread;
    data['status'] = this.status;
    data['sender_type'] = this.senderType;
    data['receiver_type'] = this.receiverType;
    data['sid'] = this.sid;

    data['file'] = this.file;
    data['sTitle'] = this.sTitle;
    data['sImage'] = this.sImage;

    return data;
  }
}
