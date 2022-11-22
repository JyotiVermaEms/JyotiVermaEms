class ChatSearchListModel {
  late final bool status;
  late final String message;
  late final List<SearchResponse> data;

  ChatSearchListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  ChatSearchListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      // data = <SearchResponse>[];
      // print(json['data']['client_results']);
      // print(json['data']['shipment_result']);

      data = List.from(json['data'])
          .map((e) => SearchResponse.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }
}

class SearchResponse {
  late final List<ClientResults> clientResults;

  late final List<ShipmentResult> shipmentResult;
  // late final int id;
  // late final String name;
  // late final String? lname;
  // late final String email;
  // late final String roles;
  // late final String? phone;
  // late final String? username;
  // late final String? countryCode;
  // late final String? country;
  // late final String? address;
  // late final String? profileimage;
  // late final String createdAt;
  // late final String updatedAt;
  // late final String? status;
  // late final String? aboutMe;
  // late final String? language;
  // late final int clientId;
  // late final String type;
  // late final String? provider;
  // late final String? otp;

  SearchResponse({
    required this.clientResults,
    required this.shipmentResult,

    // required this.id,
    // required this.name,
    // required this.lname,
    // required this.email,
    // required this.roles,
    // required this.phone,
    // required this.username,
    // required this.countryCode,
    // required this.country,
    // required this.address,
    // required this.profileimage,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.status,
    // required this.aboutMe,
    // required this.language,
    // required this.clientId,
    // required this.type,
    // required this.provider,
    // required this.otp,
  });

  SearchResponse.fromJson(Map<String, dynamic> json) {
    clientResults = List.from(json['client_results'])
        .map((e) => ClientResults.fromJson(e))
        .toList();
    shipmentResult = List.from(json['shipment_result'])
        .map((e) => ShipmentResult.fromJson(e))
        .toList();
    // id = json['id'];
    // name = json['name'];
    // lname = json['lname'];
    // email = json['email'];
    // roles = json['roles'];
    // phone = json['phone'] ?? "";
    // username = json['username'] ?? "";
    // countryCode = json['country_code'] ?? "";
    // country = json['country'] ?? "";
    // address = json['address'] ?? "";
    // profileimage = json['profileimage'] ?? "";
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // status = json['status'] ?? "";
    // aboutMe = json['about_me'] ?? "";
    // language = json['language'] ?? "";
    // clientId = json['client_id'] ?? 0;
    // type = json['type'] ?? "";
    // provider = json['provider'] ?? "";
    // otp = json['otp'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['client_results'] = clientResults.map((e) => e.toJson()).toList();
    data['shipment_result'] = shipmentResult.map((e) => e.toJson()).toList();

    // data['id'] = this.id;
    // data['name'] = this.name;
    // data['lname'] = this.lname;
    // data['email'] = this.email;
    // data['roles'] = this.roles;
    // data['phone'] = this.phone;
    // data['username'] = this.username;
    // data['country_code'] = this.countryCode;
    // data['country'] = this.country;
    // data['address'] = this.address;
    // data['profileimage'] = this.profileimage;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    // data['status'] = this.status;
    // data['about_me'] = this.aboutMe;
    // data['language'] = this.language;
    // data['client_id'] = this.clientId;
    // data['type'] = this.type;
    // data['provider'] = this.provider;
    // data['otp'] = this.otp;
    // print("-=-=- $data");
    return data;
  }
}

class ClientResults {
  ClientResults({
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    required this.username,
    required this.countryCode,
    required this.country,
    required this.address,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.aboutMe,
    required this.language,
    required this.clientId,
    required this.type,
    required this.provider,
    required this.otp,
  });
  late final int id;
  late final String name;
  late final String? lname;
  late final String email;
  late final String roles;
  late final String? phone;
  late final String? username;
  late final String? countryCode;
  late final String? country;
  late final String? address;
  late final String? profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final String? status;
  late final String? aboutMe;
  late final String? language;
  late final int clientId;
  late final String type;
  late final String? provider;
  late final String? otp;

  ClientResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'] ?? "";
    username = json['username'] ?? "";
    countryCode = json['country_code'] ?? "";
    country = json['country'] ?? "";
    address = json['address'] ?? "";
    profileimage = json['profileimage'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] ?? "";
    aboutMe = json['about_me'] ?? "";
    language = json['language'] ?? "";
    clientId = json['client_id'] ?? 0;
    type = json['type'] ?? "";
    provider = json['provider'] ?? "";
    otp = json['otp'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['country_code'] = this.countryCode;
    data['country'] = this.country;
    data['address'] = this.address;
    data['profileimage'] = this.profileimage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['about_me'] = this.aboutMe;
    data['language'] = this.language;
    data['client_id'] = this.clientId;
    data['type'] = this.type;
    data['provider'] = this.provider;
    data['otp'] = this.otp;
    print("-=-=- $data");
    return data;
  }
}

class ShipmentResult {
  ShipmentResult({
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.roles,
    required this.phone,
    required this.username,
    required this.countryCode,
    required this.country,
    required this.address,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.aboutMe,
    required this.language,
    required this.clientId,
    required this.type,
    required this.provider,
    required this.otp,
  });
  late final int id;
  late final String name;
  late final String? lname;
  late final String email;
  late final String roles;
  late final String? phone;
  late final String? username;
  late final String? countryCode;
  late final String? country;
  late final String? address;
  late final String? profileimage;
  late final String createdAt;
  late final String updatedAt;
  late final String? status;
  late final String? aboutMe;
  late final String? language;
  late final int clientId;
  late final String type;
  late final String? provider;
  late final String? otp;

  ShipmentResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    email = json['email'];
    roles = json['roles'];
    phone = json['phone'] ?? "";
    username = json['username'] ?? "";
    countryCode = json['country_code'] ?? "";
    country = json['country'] ?? "";
    address = json['address'] ?? "";
    profileimage = json['profileimage'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] ?? "";
    aboutMe = json['about_me'] ?? "";
    language = json['language'] ?? "";
    clientId = json['client_id'] ?? 0;
    type = json['type'] ?? "";
    provider = json['provider'] ?? "";
    otp = json['otp'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['country_code'] = this.countryCode;
    data['country'] = this.country;
    data['address'] = this.address;
    data['profileimage'] = this.profileimage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['about_me'] = this.aboutMe;
    data['language'] = this.language;
    data['client_id'] = this.clientId;
    data['type'] = this.type;
    data['provider'] = this.provider;
    data['otp'] = this.otp;
    print("-=-=- $data");
    return data;
  }
}
