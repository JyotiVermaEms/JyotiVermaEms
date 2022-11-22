class ShipmentRegisterModel {
  ShipmentRegisterModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ShipmentRegisterModel.fromJson(Map<String, dynamic> json) {
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
    required this.name,
    required this.lname,
    required this.email,
    required this.phone,
    required this.username,
    required this.countryCode,
    required this.companyname,
    required this.annualshipment,
    required this.country,
    required this.roles,
    required this.profileimage,
    required this.status,
    required this.type,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.token,
  });
  late final String name;
  late final String lname;
  late final String email;
  late final String phone;
  late final String username;
  late final int countryCode;
  late final String companyname;
  late final String annualshipment;
  late final String country;
  late final String roles;
  late final String profileimage;
  late final String status;
  late final String type;
  late final String updatedAt;
  late final String createdAt;
  late final int id;
  late final String token;

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    phone = json['phone'];
    username = json['username'];
    countryCode = json['country_code'] ?? 0;
    companyname = json['companyname'] ?? "";
    annualshipment = json['annualshipment'] ?? "";
    country = json['country'] ?? "";
    roles = json['roles'];
    profileimage = json['profileimage'] ?? "";
    status = json['status'];
    type = json['type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'] ?? 0;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['username'] = username;
    _data['country_code'] = countryCode;
    _data['companyname'] = companyname;
    _data['annualshipment'] = annualshipment;
    _data['country'] = country;
    _data['roles'] = roles;
    _data['profileimage'] = profileimage;
    _data['status'] = status;
    _data['type'] = type;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    _data['token'] = token;
    return _data;
  }
}
