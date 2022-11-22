class SchduleShipmentReviewModel {
  SchduleShipmentReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  SchduleShipmentReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.uid,
    required this.rating,
    required this.recommend,
    required this.comment,
    required this.sid,
    required this.image,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final int uid;
  late final String rating;
  late final String recommend;
  late final String comment;
  late final String sid;
  late final String image;
  late final String updatedAt;
  late final String createdAt;
  late final int id;

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] == null ? 0 : json['uid'];
    rating = json['rating'];
    recommend = json['recommend'];
    comment = json['comment'];
    sid = json['sid'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['rating'] = rating;
    _data['recommend'] = recommend;
    _data['comment'] = comment;
    _data['sid'] = sid;
    _data['image'] = image;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}
