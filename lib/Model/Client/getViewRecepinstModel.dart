class UserManageMentModel {
  UserManageMentModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<UserData> data;

  UserManageMentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => UserData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class UserData {
  late bool isExpanded;

  UserData({
    required this.isExpanded,
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    this.username,
    required this.countryCode,
    required this.country,
    required this.address,
    this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.aboutMe,
    this.language,
    required this.clientId,
    required this.type,
    this.provider,
    required this.otp,
  });

  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String roles;
  late final String phone;
  late final Null username;
  late final String countryCode;
  late final String country;
  late final String address;
  late final String? profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final String status;
  late final Null aboutMe;
  late final Null language;
  late final int clientId;
  late final String type;
  late final Null provider;
  late final String otp;

  UserData.fromJson(Map<String, dynamic> json) {
    isExpanded = json['is_expanded'] == null ? false : true;
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'];
    username = null;
    countryCode = json['country_code'];
    country = json['country'] ?? "";
    address = json['address'] ?? "";
    profileimage = json['profileimage'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] ?? "";
    aboutMe = null;
    language = null;
    clientId = json['client_id'];
    type = json['type'];
    provider = null;
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['roles'] = roles;
    _data['phone'] = phone;
    _data['username'] = username;
    _data['country_code'] = countryCode;
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
    _data['otp'] = otp;
    return _data;
  }
}
