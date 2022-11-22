class MapModel {
  MapModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  MapModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.businessStatus,
    required this.formattedAddress,
    required this.geometry,
    required this.viewport,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.openingHours,
  });
  late final String businessStatus;
  late final String formattedAddress;
  late final List<String> geometry;
  late final List<String> viewport;
  late final String icon;
  late final String iconBackgroundColor;
  late final String iconMaskBaseUri;
  late final String name;
  late final List<String> openingHours;

  Data.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    formattedAddress = json['formatted_address'];
    geometry = List.castFrom<dynamic, String>(json['geometry']);
    viewport = List.castFrom<dynamic, String>(json['viewport']);
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    openingHours = List.castFrom<dynamic, String>(json['opening_hours']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['business_status'] = businessStatus;
    _data['formatted_address'] = formattedAddress;
    _data['business_status'] = businessStatus;
    _data['geometry'] = geometry;
    _data['icon'] = icon;
    _data['icon_background_color'] = iconBackgroundColor;
    _data['icon_mask_base_uri'] = iconMaskBaseUri;
    _data['name'] = name;
    _data['opening_hours'] = openingHours;

    return _data;
  }
}
