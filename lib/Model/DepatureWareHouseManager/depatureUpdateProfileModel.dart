class UpdateDepatureProflieModel {
  UpdateDepatureProflieModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  UpdateDepatureProflieModel.fromJson(Map<String, dynamic> json) {
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
    this.countryCode,
    required this.companyname,
    required this.annualshipment,
    required this.country,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.profileimage,
    this.docs,
    this.status,
    this.drivingLicence,
    this.taxDocs,
    required this.aboutMe,
    required this.language,
    this.type,
    required this.shipmentId,
    this.provider,
    this.otp,
  });
  late final int id;
  late final String name;
  late final String lname;
  late final String email;
  late final String phone;
  late final String username;
  late final Null countryCode;
  late final String companyname;
  late final String annualshipment;
  late final String country;
  late final String address;
  late final String createdAt;
  late final String updatedAt;
  late final String roles;
  late final Null profileimage;
  late final Null docs;
  late final Null status;
  late final Null drivingLicence;
  late final Null taxDocs;
  late final String aboutMe;
  late final String language;
  late final Null type;
  late final int shipmentId;
  late final Null provider;
  late final Null otp;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    phone = json['phone'];
    username = json['username'];
    countryCode = null;
    companyname = json['companyname'] == null ? "" : json['companyname'];
    annualshipment =
        json['annualshipment'] == null ? "" : json['annualshipment'];
    country = json['country'];
    address = json['address'] == null ? "" : json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roles = json['roles'];
    profileimage = null;
    docs = null;
    status = null;
    drivingLicence = null;
    taxDocs = null;
    aboutMe = json['about_me'];
    language = json['language'] == null ? "" : json['language'];
    type = null;
    shipmentId = json['shipment_id'];
    provider = null;
    otp = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['lname'] = lname;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['username'] = username;
    _data['country_code'] = countryCode;
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
    _data['about_me'] = aboutMe;
    _data['language'] = language;
    _data['type'] = type;
    _data['shipment_id'] = shipmentId;
    _data['provider'] = provider;
    _data['otp'] = otp;
    return _data;
  }
}
