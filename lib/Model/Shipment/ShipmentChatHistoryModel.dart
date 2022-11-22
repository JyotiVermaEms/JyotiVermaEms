class ChatHistory {
  late bool status;
  late int statusCode;
  late String message;
  late int error;
  late List<Response> data;

  ChatHistory(
      {required this.status,
      required this.statusCode,
      required this.message,
      required this.error,
      required this.data});

  ChatHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Response>[];
      json['data'].forEach((v) {
        data.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  late int id;
  late int roomId;
  late String senderId;
  late String receiverId;
  late String message;
  late String time;
  late String date;
  late String fileType;
  late int isRead;
  late String status;
  late String jobId;
  late String createdAt;
  late String updatedAt;

  Response(
      {required this.id,
      required this.roomId,
      required this.senderId,
      required this.receiverId,
      required this.message,
      required this.time,
      required this.date,
      required this.fileType,
      required this.isRead,
      required this.status,
      required this.jobId,
      required this.createdAt,
      required this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    time = json['time'];
    date = json['date'];
    fileType = json['file_type'];
    isRead = json['is_read'];
    status = json['status'];
    jobId = json['job_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['message'] = message;
    data['time'] = time;
    data['date'] = date;
    data['file_type'] = fileType;
    data['is_read'] = isRead;
    data['status'] = status;
    data['job_id'] = jobId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
