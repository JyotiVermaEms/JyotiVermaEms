class DisplayShipmentReviewModel {
  DisplayShipmentReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<displayshipmentReview> data;

  DisplayShipmentReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => displayshipmentReview.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class displayshipmentReview {
  displayshipmentReview({
    required this.id,
    required this.uid,
    required this.rating,
    required this.recommend,
    required this.comment,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    required this.sid,
    required this.name,
    required this.profileimage,
  });
  late final int id;
  late final int uid;
  late final String rating;
  late final String recommend;
  late final String comment;
  late final String image;
  late final String createdAt;
  late final String updatedAt;
  late final String roles;
  late final int sid;
  late final String name;
  late final String profileimage;

  displayshipmentReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    rating = json['rating'];
    recommend = json['recommend'];
    comment = json['comment'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roles = json['roles'];
    sid = json['sid'];
    name = json['name'];
    profileimage = json['profileimage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['rating'] = rating;
    _data['recommend'] = recommend;
    _data['comment'] = comment;
    _data['image'] = image;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['roles'] = roles;
    _data['sid'] = sid;
    _data['name'] = name;
    _data['profileimage'] = profileimage;
    return _data;
  }
}
