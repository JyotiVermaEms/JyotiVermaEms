class UpdateClientProfileModel {
  UpdateClientProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  UpdateClientProfileModel.fromJson(Map<String, dynamic> json) {
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
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    required this.country,
    required this.address,
    this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.about_me,
    required this.language,
    required this.clientId,
    required this.type,
    this.provider,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String roles;
  late final String phone;
  late final String country;
  late final String address;
  late final Null profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final String status;
  late final String about_me;
  late final String language;
  late final int clientId;
  late final String type;
  late final Null provider;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    profileimage = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    about_me = json['about_me'];
    language = json['language'];
    clientId = json['client_id'];
    type = json['type'];
    provider = null;
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
    _data['about_me'] = about_me;
    _data['language'] = language;
    _data['client_id'] = clientId;
    _data['type'] = type;
    _data['provider'] = provider;
    return _data;
  }
}
