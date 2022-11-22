class ViewShipmentCompanyReview {
  ViewShipmentCompanyReview({
    required this.message,
    required this.review,
  });
  late final String message;
  late final List<Review> review;

  ViewShipmentCompanyReview.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    review = List.from(json['review']).map((e) => Review.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['review'] = review.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Review {
  Review({
    required this.id,
    required this.rating,
    required this.recommend,
    required this.comment,
    required this.uid,
    required this.image,
    required this.name,
  });
  late final int id;
  late final String rating;
  late final String recommend;
  late final String comment;
  late final int uid;
  late final String image;
  late final String name;

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    recommend = json['recommend'];
    comment = json['comment'];
    uid = json['uid'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['rating'] = rating;
    _data['recommend'] = recommend;
    _data['comment'] = comment;
    _data['uid'] = uid;
    _data['image'] = image;
    _data['name'] = name;
    return _data;
  }
}
