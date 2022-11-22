class ShipmentgetProfileModel {
  ShipmentgetProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ShipmentgetProfileModel.fromJson(Map<String, dynamic> json) {
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
    required this.phone,
    required this.username,
    required this.companyname,
    required this.annualshipment,
    required this.country,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    required this.profileimage,
    required this.docs,
    required this.status,
    required this.drivingLicence,
    required this.taxDocs,
    required this.about_me,
    required this.language,
    required this.type,
    required this.shipmentId,
    required this.provider,
    required this.otp,
    required this.planId,
    required this.expireDate,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String phone;
  late final String username;

  late final String companyname;
  late final String annualshipment;
  late final String country;
  late final String address;
  late final String createdAt;
  late final String updatedAt;
  late final String roles;
  late final String profileimage;
  late final String docs;
  late final String status;
  late final String drivingLicence;
  late final String taxDocs;
  late final String about_me;
  late final String language;
  late final String type;
  late final int shipmentId;
  late final String provider;
  late final String otp;
  late final int planId;
  late final String expireDate;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
    lname = json['lname'] ?? "";
    email = json['email'] == null ? "" : json['email'];
    phone = json['phone'] == "null" ? "" : json['phone'];
    username = json['username'] ?? "";

    companyname = json['companyname'] ?? "";
    annualshipment = json['annualshipment'] ?? "";
    country = json['country'] ?? "";
    address = json['address'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roles = json['roles'];
    profileimage = json['profileimage'] ?? "";
    docs = json['docs'] ?? "";
    status = json['status'];
    drivingLicence = json['driving_licence'] ?? "";
    taxDocs = json['tax_docs'] ?? "";
    about_me = json['about_me'] ?? "";
    language = json['language'] ?? "";
    type = json['type'] ?? "";
    shipmentId = json['shipmentId'] ?? 0;
    provider = json['provider'] ?? "";
    otp = json['otp'] ?? "";
    planId = json['plan_id'];
    expireDate = json['expire_date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['username'] = username;

    _data['companyname'] = companyname;
    _data['annualshipment'] = annualshipment;
    _data['country'] = country;
    _data['address'] = address;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['roles'] = roles;
    _data['profileimage'] = profileimage;
    _data['docs'] = docs;
    _data['status'] = status;
    _data['driving_licence'] = drivingLicence;
    _data['tax_docs'] = taxDocs;
    _data['about_me'] = about_me;
    _data['language'] = language;
    _data['type'] = type;
    _data['shipment_id'] = shipmentId;
    _data['provider'] = provider;
    _data['otp'] = otp;
    _data['plan_id'] = planId;
    _data['expire_date'] = expireDate;
    return _data;
  }
}
