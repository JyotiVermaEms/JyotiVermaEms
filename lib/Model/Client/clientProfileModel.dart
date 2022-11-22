class GetClientProfileModel {
  GetClientProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  GetClientProfileModel.fromJson(Map<String, dynamic> json) {
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
    required this.id,
    required this.name,
    this.lname,
    required this.email,
    required this.password,
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
    required this.type,
  });
  late final int id;
  late final String name;
  late final Null lname;
  late final String email;
  late final String password;
  late final String roles;
  late final String phone;
  late final Null country;
  late final Null address;
  late final Null profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final Null status;
  late final Null aboutMe;
  late final Null language;
  late final int clientId;
  late final String type;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    password = json['password'];
    roles = json['roles'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    profileimage = json['profileimage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    aboutMe = json['about_me'];
    language = json['language'];
    clientId = json['client_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['password'] = password;
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
    return _data;
  }
}
