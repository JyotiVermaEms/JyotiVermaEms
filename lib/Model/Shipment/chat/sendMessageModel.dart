class SendMsgModel {
  late final bool status;
  late final String message;
  late final int error;

  late final List<SendMsgResponse> data;

  SendMsgModel(
      {required this.status, required this.message, required this.data});

  SendMsgModel.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SendMsgResponse>[];
      json['data'].forEach((v) {
        data.add(SendMsgResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SendMsgResponse {
  late final int messageId;
  late final String messageType;
  late final String message;
  late final int roomId;
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
  late final int isread;
  late final String status;
  late final String senderType;
  late final String receiverType;

  SendMsgResponse({
    required this.messageId,
    required this.messageType,
    required this.message,
    required this.roomId,
    required this.receiverId,
    required this.senderId,
    required this.date,
    required this.time,
    required this.fileType,
    required this.jobStatus,
    required this.tobydeletestatus,
    required this.createdAt,
    required this.updatedAt,
    required this.byuserdeletestatus,
    required this.isread,
    required this.status,
    required this.senderType,
    required this.receiverType,
  });

  SendMsgResponse.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    messageType = json['message_type'];

    message = json['message'];
    roomId = json['room_id'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    date = json['date'];
    time = json['time'];

    fileType = json['fileType'] ?? "";
    jobStatus = json['job_status'];
    tobydeletestatus = json['tobydeletestatus'];
    createdAt = json['created_At'];
    updatedAt = json['updated_At'];
    byuserdeletestatus = json['byuserdeletestatus'];
    isread = json['isread'];
    status = json['status'];
    senderType = json['sender_type'];
    receiverType = json['receiver_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = messageId;
    data['message_type'] = messageType;
    data['message'] = message;
    data['room_id'] = roomId;
    data['receiver_id'] = receiverId;
    data['sender_id'] = senderId;
    data['date'] = date;
    data['time'] = time;
    data['fileType'] = fileType;

    data['job_status'] = jobStatus;
    data['tobydeletestatus'] = tobydeletestatus;
    data['created_At'] = createdAt;
    data['updated_At'] = updatedAt;
    data['byuserdeletestatus'] = byuserdeletestatus;
    data['isread'] = isread;
    data['status'] = status;
    data['sender_type'] = senderType;
    data['receiver_type'] = receiverType;

    return data;
  }
}
