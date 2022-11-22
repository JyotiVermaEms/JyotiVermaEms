// ignore_for_file: prefer_if_null_operators

class SocialLoginModel {
  SocialLoginModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    // print("_data-=-=-= $json");
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();

    // print("_data-=-=-=>>> $data");
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
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    this.country,
    this.address,
    this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    this.aboutMe,
    this.language,
    required this.clientId,
    this.type,
    required this.provider,
    required this.token,
  });
  late final int id;
  late final String name;
  late final String? lname;
  late final String email;
  late final String? roles;
  late final String? phone;
  late final String? country;
  late final Null address;
  late final Null profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final Null status;
  late final Null aboutMe;
  late final Null language;
  late final int? clientId;
  late final Null type;
  late final String provider;
  late final String token;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'] == null ? "" : json['lname'];
    email = json['email'];
    roles = json['roles'] == null ? "" : json['roles'];
    phone = json['phone'] == null ? "" : json['phone'];
    country = json['country'] == null ? "" : json['country'];
    address = null;
    profileimage = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = null;
    aboutMe = null;
    language = null;
    clientId = json['client_id'];
    type = null;
    provider = json['provider'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['roles'] = roles;
    _data['phone'] = phone;
    _data['country'] = country;
    _data['address'] = address;
    _data['profileimage'] = profileimage;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['status'] = status;
    _data['about_me'] = aboutMe;
    _data['language'] = language;
    _data['client_id'] = clientId;
    _data['type'] = type;
    _data['provider'] = provider;
    _data['token'] = token;
    return _data;
  }
}
