class AddEmployeeModel {
  AddEmployeeModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  AddEmployeeModel.fromJson(Map<String, dynamic> json) {
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
    required this.country,
    required this.address,
    required this.roles,
    required this.profileimage,
    required this.shipmentId,
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
  late final String country;
  late final String address;
  late final String roles;
  late final String profileimage;
  late final int shipmentId;
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
    country = json['country'];
    address = json['address'];
    roles = json['roles'];
    profileimage = json['profileimage'];
    shipmentId = json['shipment_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['username'] = username;
    _data['country'] = country;
    _data['address'] = address;
    _data['roles'] = roles;
    _data['profileimage'] = profileimage;
    _data['shipment_id'] = shipmentId;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    _data['token'] = token;
    return _data;
  }
}
